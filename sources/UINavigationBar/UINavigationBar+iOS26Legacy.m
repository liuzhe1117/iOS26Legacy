//
//  UINavigationBar+iOS26Legacy.m
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import "UINavigationBar+iOS26Legacy.h"
#import "iOS26Legacy.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation UINavigationBar (iOS26Legacy)

+ (void)load {
    if (![iOS26Legacy enable]) {
        return;
    }
                
    RSSwizzleInstanceMethod(UIBarButtonItem.class,
                            NSSelectorFromString(@"hidesSharedBackground"),
                            RSSWReturnType(BOOL),
                            RSSWArguments(),
                            RSSWReplacement({
        return YES;
        RSSWCallOriginal();//消除警告
    }), RSSwizzleModeAlways, nil)
    
    RSSwizzleInstanceMethod(UIBarButtonItem.class,
                            NSSelectorFromString(@"sharesBackground"),
                            RSSWReturnType(BOOL),
                            RSSWArguments(),
                            RSSWReplacement({
        return NO;
        RSSWCallOriginal();//消除警告
    }), RSSwizzleModeAlways, nil)
}

@end
