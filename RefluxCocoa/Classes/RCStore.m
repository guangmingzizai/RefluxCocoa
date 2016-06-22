//
//  RCStore.m
//  RefluxCocoa
//
//  Created by liuyaodong on 11/12/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "RCStore.h"
#import "RCEvent.h"
#import "RCSubscriber.h"
#import "RCObservable.h"
#import <objc/runtime.h>

@interface RCStore ()<RCSubscribableDelegate>
@property (nonatomic, strong) NSMutableSet *subscribables;
@property (nonatomic, copy) void (^output)(id);
@property (nonatomic, copy) void (^error)(NSError *);
@end

@implementation RCStore

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _subscribables = [NSMutableSet set];
    }
    return self;
}

- (void)listenTo:(Class)observableClass withEventName:(NSString *)eventName
{
    NSAssert([observableClass conformsToProtocol:@protocol(RCObservable)], @"%@ is not conform to `RCObservable`", [observableClass class]);
    [self rc_listenTo:observableClass withEvent:[observableClass eventForName:eventName]];
}

- (void)rc_listenTo:(Class)observableClass withEvent:(RCEvent *)event
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:event.eventName object:observableClass];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dispatch:) name:event.eventName object:observableClass];
}

- (void)listenToAllEventsOf:(Class)observableClass
{
    NSAssert([observableClass conformsToProtocol:@protocol(RCObservable)], @"%@ is not conform to `RCObservable`", [observableClass class]);
    for (RCEvent *event in [observableClass events]) {
        [self rc_listenTo:observableClass withEvent:event];
    }
}

- (void)joinTrailingOfEvents:(NSArray *)events withCallback:(void (^)(NSArray *arguments))callback;
{
    NSAssert(NO, @"该接口未能通过测试");
    NSParameterAssert(callback);
    NSParameterAssert(events);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t serialQueue = dispatch_queue_create("com.refluxcocoa.rcstore.jointrailing", DISPATCH_QUEUE_SERIAL);
    
    NSMutableArray *trailingArguments = [NSMutableArray arrayWithCapacity:events.count];
    NSMutableArray *fulfill = [NSMutableArray arrayWithCapacity:events.count];
    
    for (int i = 0; i < events.count; i++) {
        
        RCEvent *event = events[i];
        NSAssert([event isMemberOfClass:[RCEvent class]], @"");
        
        dispatch_async(serialQueue, ^{
            // Use null as placeholder
            [trailingArguments addObject:[NSNull null]];
            [fulfill addObject:@(NO)];
        
            dispatch_group_enter(group);
            
            [[NSNotificationCenter defaultCenter] addObserverForName:event.eventName
                                                              object:NSClassFromString(event.className)
                                                               queue:nil // run in current thread
                                                          usingBlock:^(NSNotification *note) {
                
                id object = note.userInfo[@"object"];
                if (!object) {
                    object = [NSNull null];
                }
                trailingArguments[i] = object;
                
                if (![fulfill[i] boolValue]) {
                    fulfill[i] = @(YES);
                    dispatch_group_leave(group);
                }
                
            }];
        });

    }
    
    dispatch_group_notify(group, serialQueue, ^{
        callback([trailingArguments copy]);
    });
}

#pragma mark - Trigger
- (id)initialState
{
    return nil;
}

- (void)output:(id)object
{
    [[self.subscribables copy] makeObjectsPerformSelector:@selector(output:) withObject:object];
}

- (void)error:(NSError *)error
{
    [[self.subscribables copy] makeObjectsPerformSelector:@selector(error:) withObject:error];
}

- (void)completed
{
    [[self.subscribables copy] makeObjectsPerformSelector:@selector(completed)];
}

#pragma mark - Subscribe
- (id<RCUnsubscribable>)makeTarget:(id)target subscribeOutput:(void (^)(id object))output
{
    return [self makeTarget:target subscribeOuput:output error:nil initialCallback:nil];
}

- (id<RCUnsubscribable>)makeTarget:(id)target subscribeOutput:(void (^)(id object))output error:(void (^)(NSError *error))error
{
    return [self makeTarget:target subscribeOuput:output error:error initialCallback:nil];
}

- (id<RCUnsubscribable>)makeTarget:(id)target
                subscribeOuput:(void (^)(id object))output
                         error:(void (^)(NSError *error))error
               initialCallback:(void (^)(id object))initialCallback
{
    return [self makeTarget:target subscribeOuput:output completion:nil error:error initialCallback:initialCallback whenEventTriggered:nil finally:nil];
}

- (id<RCUnsubscribable>)makeTarget:(id)target
                    subscribeOuput:(void (^)(id object))output
                        completion:(void (^)(void))completion
                             error:(void (^)(NSError *error))error
                   initialCallback:(void (^)(id object))initialCallback
                whenEventTriggered:(void (^)(void))whenEventTriggeredBlock
                           finally:(void (^)(void))finallyBlock
{
    RCSubscriber *subscribable = nil;
    for (RCSubscriber *theSubscribable in self.subscribables) {
        if (theSubscribable.target == target) {
            subscribable = theSubscribable;
            break;
        }
    }
    if (subscribable == nil) {
        subscribable = [RCSubscriber subscribableWithTarget:target output:output completion:completion error:error whenEventTriggered:whenEventTriggeredBlock finally:finallyBlock delegate:self];
        [self.subscribables addObject:subscribable];
    }
    if (initialCallback) {
        initialCallback([self initialState]);
    }
    
    return subscribable;
}

#pragma mark - RCSubscrabableDelegate
- (void)subscribable:(RCSubscriber *)subscribable didMakeTargetUnsubscribed:(id)target
{
    [self.subscribables removeObject:subscribable];
}

#pragma mark - dispatcher
- (void)dispatch:(NSNotification *)note
{
    id object = note.userInfo[@"object"];
    RCEvent *event = note.userInfo[@"event"];
    
    [self.subscribables makeObjectsPerformSelector:@selector(performEventTriggeredBlock)];
    
    NSString *methodName = methodSimularToEventName(methodsOfObject([self class]), event);
    if (methodName) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(methodName) withObject:object];
#pragma clang diagnostic pop
    }
}

#pragma mark - Helper

static NSArray * methodsOfObject(Class clz)
{
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(clz, &methodCount);
    
    NSMutableArray *methodArray = [NSMutableArray arrayWithCapacity:methodCount];
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        [methodArray addObject:NSStringFromSelector(method_getName(method))];
    }
    
    free(methods);
    return methodArray;
}

static NSString * methodSimularToEventName(NSArray *methods, RCEvent *event)
{
    for (NSString *methodName in methods) {
        if ([event matchName:methodName]) {
            return methodName;
        }
    }
    return nil;
}

@end
