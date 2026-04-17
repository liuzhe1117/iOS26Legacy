//
//  UIViewController+iOS26Legacy.m
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import "UIViewController+iOS26Legacy.h"
#import "iOS26Legacy.h"
#import <RSSwizzle/RSSwizzle.h>
#import <objc/runtime.h>

static const void *kCustomHidesBottomBarWhenPushedKey = &kCustomHidesBottomBarWhenPushedKey;

@implementation UIViewController (iOS26Legacy)

+ (void)load {
    if (![iOS26Legacy enable]) {
        return;
    }
        
    RSSwizzleInstanceMethod(UIViewController.class,
                            @selector(hidesBottomBarWhenPushed),
                            RSSWReturnType(BOOL),
                            RSSWArguments(),
                            RSSWReplacement({
            return NO;
            RSSWCallOriginal();
    }), RSSwizzleModeAlways, nil)

    RSSwizzleInstanceMethod(UIViewController.class,
                            @selector(setHidesBottomBarWhenPushed:),
                            RSSWReturnType(void),
                            RSSWArguments(BOOL hidesBottomBarWhenPushed),
                            RSSWReplacement({
            objc_setAssociatedObject(self,
                                     kCustomHidesBottomBarWhenPushedKey,
                                     @(hidesBottomBarWhenPushed),
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            RSSWCallOriginal(NO);
    }), RSSwizzleModeAlways, nil)
}

- (BOOL)customHidesBottomBarWhenPushed {
    NSNumber *customValue = objc_getAssociatedObject(self, kCustomHidesBottomBarWhenPushedKey);
    return [customValue boolValue];
}

@end
