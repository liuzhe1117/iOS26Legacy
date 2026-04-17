//
//  IOS26LegacyNavigationControllerDelegateProxy.m
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import "IOS26LegacyNavigationControllerDelegateProxy.h"
#import <objc/runtime.h>

@interface UINavigationController (iOS26LegacyTabBarPrivate)
- (void)changeTabbarStatusIfNeeded;
@end

static BOOL IOS26LegacyDelegateTargetImplements(id target, SEL selector) {
    return target != nil && class_respondsToSelector(object_getClass(target), selector);
}

@implementation IOS26LegacyNavigationControllerDelegateProxy

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    return IOS26LegacyDelegateTargetImplements(self.forwardedDelegate, aSelector);
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id forwarded = self.forwardedDelegate;
    if (IOS26LegacyDelegateTargetImplements(forwarded, aSelector)) {
        return forwarded;
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [navigationController changeTabbarStatusIfNeeded];
    id<UINavigationControllerDelegate> forwarded = self.forwardedDelegate;
    if (IOS26LegacyDelegateTargetImplements(forwarded, _cmd)) {
        [forwarded navigationController:navigationController
                 willShowViewController:viewController
                               animated:animated];
    }
}

@end
