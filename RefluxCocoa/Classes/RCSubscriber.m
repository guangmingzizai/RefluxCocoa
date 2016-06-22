//
//  RCSubscribable.m
//  RefluxCocoa
//
//  Created by liuyaodong on 11/15/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "RCSubscriber.h"

@interface RCSubscriber ()
@property (nonatomic, weak) id target;
@property (nonatomic, copy) void (^output)(id);
@property (nonatomic, copy) void (^error)(NSError *);
@property (nonatomic, copy) void (^eventTriggeredBlock)(void);
@property (nonatomic, copy) void (^finally)(void);
@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, weak) id<RCSubscribableDelegate> delegate;
@property (nonatomic) BOOL subscribed;
@end

@implementation RCSubscriber

+ (instancetype)subscribableWithTarget:(id)target
                                output:(void (^)(id object))output
                            completion:(void (^)(void))completion
                                 error:(void (^)(NSError *error))error
                    whenEventTriggered:(void (^)(void))whenEventTriggeredBlock
                               finally:(void (^)(void))finally
                              delegate:(id<RCSubscribableDelegate>)delegate
{
    NSParameterAssert(delegate);
    NSParameterAssert(output);
    NSParameterAssert(target);
    
    RCSubscriber *subscribable = [RCSubscriber new];
    subscribable.delegate = delegate;
    subscribable.target = target;
    subscribable.output = output;
    subscribable.error = error;
    subscribable.completion = completion;
    subscribable.eventTriggeredBlock = whenEventTriggeredBlock;
    subscribable.finally = finally;
    subscribable.subscribed = YES;
    return subscribable;
}

- (void)output:(id)object
{
    if (self.target) {
        if (self.output) {
            self.output(object);
        }
    } else {
        [self unsubscribe];
    }
}

- (void)error:(NSError *)error
{
    if (self.target) {
        if (self.error) {
            self.error(error);
        }
        
        if (self.finally) {
            self.finally();
        }
    } else {
        [self unsubscribe];
    }
}

- (void)completed
{
    if (self.target) {
        if (self.completion) {
            self.completion();
        }
        
        if (self.finally) {
            self.finally();
        }
    } else {
        [self unsubscribe];
    }
}

- (void)performEventTriggeredBlock
{
    if (self.eventTriggeredBlock) {
        self.eventTriggeredBlock();
    }
}

- (void)unsubscribe
{
    self.subscribed = NO;
    [self.delegate subscribable:self didMakeTargetUnsubscribed:self.target];
}
@end
