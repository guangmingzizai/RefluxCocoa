//
//  RCUnsubscribable.h
//  RefluxCocoa
//
//  Created by liuyaodong on 11/15/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCUnsubscribable <NSObject>
@property (nonatomic, readonly) BOOL subscribed;
- (void)unsubscribe;
@end
