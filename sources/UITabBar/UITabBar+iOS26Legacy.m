//
//  UITabBar+iOS26Legacy.m
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import "UITabBar+iOS26Legacy.h"
#import "iOS26Legacy.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation UITabBar (iOS26Legacy)

+ (void)load {
    if (![iOS26Legacy enable]) {
        return;
    }
        
    RSSwizzleInstanceMethod(UITabBar.class,
                            @selector(addSubview:),
                            RSSWReturnType(void),
                            RSSWArguments(UIView *view),
                            RSSWReplacement({
        NSString *className = NSStringFromClass(view.class);
        if ([className rangeOfString:@"_UITabBarPlatterView"].location != NSNotFound) {
            view.hidden = YES;
            view.alpha = 0;
        }
        RSSWCallOriginal(view);
    }), RSSwizzleModeAlways, nil)
    
    RSSwizzleInstanceMethod(UITabBar.class,
                            @selector(addGestureRecognizer:),
                            RSSWReturnType(void),
                            RSSWArguments(UIGestureRecognizer *gestureRecognizer),
                            RSSWReplacement({
        NSString *className = NSStringFromClass(gestureRecognizer.class);
        if ([className rangeOfString:@"_UIContinuousSelectionGestureRecognizer"].location != NSNotFound) {
            gestureRecognizer.enabled = NO;
        }
        RSSWCallOriginal(gestureRecognizer);
    }), RSSwizzleModeAlways, nil)

}

@end
