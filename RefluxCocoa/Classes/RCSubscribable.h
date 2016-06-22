//
//  RCSubscribable.h
//  RefluxCocoa
//
//  Created by liuyaodong on 11/16/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCUnsubscribable.h"

@class RACSignal;

@protocol RCSubscribable <NSObject>
- (id<RCUnsubscribable>)makeTarget:(id)target subscribeOutput:(void (^)(id object))output;

- (id<RCUnsubscribable>)makeTarget:(id)target subscribeOutput:(void (^)(id object))output error:(void (^)(NSError *error))error;

- (id<RCUnsubscribable>)makeTarget:(id)target
                    subscribeOuput:(void (^)(id object))output
                             error:(void (^)(NSError *error))error
                   initialCallback:(void (^)(id object))initialCallback;

- (id<RCUnsubscribable>)makeTarget:(id)target
                    subscribeOuput:(void (^)(id object))output
                        completion:(void (^)(void))completion
                             error:(void (^)(NSError *error))error
                   initialCallback:(void (^)(id object))initialCallback
                whenEventTriggered:(void (^)(void))whenEventTriggeredBlock
                           finally:(void (^)(void))finallyBlock;

@end
