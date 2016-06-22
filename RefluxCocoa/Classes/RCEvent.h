//
//  RCEvent.h
//  RefluxCocoa
//
//  Created by liuyaodong on 11/13/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCEvent : NSObject
@property (nonatomic, readonly) NSString *eventName;
@property (nonatomic, copy, readonly) NSString *className;
+ (instancetype)eventWithName:(NSString *)name actionClass:(Class)cls;
- (BOOL)matchName:(NSString *)name;
@end
