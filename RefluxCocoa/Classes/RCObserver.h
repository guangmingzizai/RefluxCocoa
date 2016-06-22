//
//  RCObserver.h
//  RefluxCocoa
//
//  Created by liuyaodong on 11/12/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCObserver <NSObject>
- (void)listenTo:(Class)observableClass withEventName:(NSString *)eventName;
- (void)listenToAllEventsOf:(Class)observableClass;
@end
