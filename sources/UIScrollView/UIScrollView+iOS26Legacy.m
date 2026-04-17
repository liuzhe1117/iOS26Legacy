//
//  UIScrollView+iOS26Legacy.m
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import "UIScrollView+iOS26Legacy.h"
#import "iOS26Legacy.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation UIScrollView (iOS26Legacy)

+ (void)load {
    if (![iOS26Legacy enable]) {
        return;
    }

    Class edgeEffectClass = NSClassFromString(@"UIScrollEdgeEffect");
    if (edgeEffectClass) {
        RSSwizzleInstanceMethod(edgeEffectClass,
                                NSSelectorFromString(@"isHidden"),
                                RSSWReturnType(BOOL),
                                RSSWArguments(),
                                RSSWReplacement({
            return YES;
            RSSWCallOriginal();
        }), RSSwizzleModeAlways, nil)
    }
}

@end
