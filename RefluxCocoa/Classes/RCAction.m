//
//  RCAction.m
//  RefluxCocoa
//
//  Created by liuyaodong on 11/12/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "RCAction.h"
#import "RCEvent.h"
#import <objc/runtime.h>

@implementation RCAction

+ (NSArray *)eventDefinitions
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

+ (NSArray *)events
{
    NSArray *events = objc_getAssociatedObject(self, @selector(events));
    if (!events) {
        NSMutableArray *mutableEvents = [NSMutableArray arrayWithCapacity:[self eventDefinitions].count];
        for (NSString *eventName in [self eventDefinitions]) {
            [mutableEvents addObject:[RCEvent eventWithName:eventName actionClass:self]];
        }
        events = [mutableEvents copy];
        objc_setAssociatedObject(self, @selector(events), events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return events;
}

+ (RCEvent *)eventForName:(NSString *)name
{
    for (RCEvent *event in [self events]) {
        if ([event matchName:name]) {
            return event;
        }
    }
    return nil;
}

+ (void)triggerEvent:(NSString *)eventName
{
    [self triggerEvent:eventName withObject:nil];
}

+ (void)triggerEvent:(NSString *)eventName withObject:(id)object
{
    RCEvent *event = [RCEvent eventWithName:eventName actionClass:[self class]];
    NSAssert([[self events] containsObject:event], @"Event [%@] is not defined by %@", event, self);
    NSMutableDictionary *userInfo = [@{@"event": event} mutableCopy];
    if (object) {
        userInfo[@"object"] = object;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:event.eventName object:self userInfo:[userInfo copy]];
}

@end
