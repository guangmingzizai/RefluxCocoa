//
//  RCSubscribable.h
//  RefluxCocoa
//
//  Created by liuyaodong on 11/15/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCUnsubscribable.h"

@protocol RCSubscribableDelegate;

@interface RCSubscriber : NSObject<RCUnsubscribable>
@property (nonatomic, readonly) BOOL subscribed;

+ (instancetype)subscribableWithTarget:(id)target
                                output:(void (^)(id object))output
                            completion:(void (^)(void))completion
                                 error:(void (^)(NSError *error))error
                    whenEventTriggered:(void (^)(void))whenEventTriggeredBlock
                               finally:(void (^)(void))finally
                              delegate:(id<RCSubscribableDelegate>)delegate;
@property (nonatomic, readonly, weak) id target;

- (void)output:(id)object;
- (void)error:(NSError *)error; // Will unsubscribe automatically
- (void)completed; // Will unsubscribe automatically
- (void)unsubscribe;
- (void)performEventTriggeredBlock;
@end

@protocol RCSubscribableDelegate <NSObject>
- (void)subscribable:(RCSubscriber *)subscribable didMakeTargetUnsubscribed:(id)target;
@end
