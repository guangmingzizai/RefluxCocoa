//
//  RCObservable.h
//  RefluxCocoa
//
//  Created by liuyaodong on 11/12/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCEvent;

@protocol RCObservable <NSObject>
+ (NSArray *)events;
+ (RCEvent *)eventForName:(NSString *)name;
+ (void)triggerEvent:(NSString *)event;
+ (void)triggerEvent:(NSString *)event withObject:(id)object;
@end
