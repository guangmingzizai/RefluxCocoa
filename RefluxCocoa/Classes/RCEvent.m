//
//  RCEvent.m
//  RefluxCocoa
//
//  Created by liuyaodong on 11/13/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "RCEvent.h"

@interface RCEvent ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *className;
@end

@implementation RCEvent

@dynamic eventName;

+ (instancetype)eventWithName:(NSString *)name actionClass:(Class)cls
{
    RCEvent *event = [RCEvent new];
    event.className = NSStringFromClass(cls);
    event.name = [name lowercaseString];
    return event;
}

- (NSString *)eventName
{
    return [NSString stringWithFormat:@"%@_%@", self.className, self.name];
}

- (BOOL)matchName:(NSString *)name
{
    return matchAllHomogeneousName(@[
                                     [NSString stringWithFormat:@"%@:", self.name],
                                     [NSString stringWithFormat:@"on%@:", self.name],
                                     [NSString stringWithFormat:@"on%@", self.name],
                                     self.name,
                                     ], name);
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    if ([object isMemberOfClass:[RCEvent class]]) {
        return [((RCEvent *)object).eventName isEqualToString:self.eventName];
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return [self.eventName hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - name<%@>", [super description], self.name];
}


#pragma mark - Helper
static BOOL matchAllHomogeneousName(NSArray *homogeneousNames, NSString *name)
{
    for(NSString *n in homogeneousNames) {
        if (caseInsensitiveMatch(n, name)) {
            return YES;
        }
    }
    return NO;
}

static BOOL caseInsensitiveMatch(NSString *methodName, NSString *name)
{
    return [methodName caseInsensitiveCompare:name] == NSOrderedSame;
}

@end
