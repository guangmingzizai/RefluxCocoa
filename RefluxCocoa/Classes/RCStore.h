//
//  RCStore.h
//  RefluxCocoa
//
//  Created by liuyaodong on 11/12/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCObserver.h"
#import "RCSubscribable.h"

@interface RCStore : NSObject<RCObserver, RCSubscribable>

- (void)listenTo:(Class)observableClass withEventName:(NSString *)eventName;
- (void)listenToAllEventsOf:(Class)observableClass;
- (void)joinTrailingOfEvents:(NSArray *)events withCallback:(void (^)(NSArray *arguments))callback;

// 若target被dealloc, 则自动将其置为unsubscribed. 即，若一个对象不调用-unscribscribe方法，也是安全的。
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


- (id)initialState;
- (void)output:(id)object;
- (void)error:(NSError *)error;
- (void)completed;

@end
