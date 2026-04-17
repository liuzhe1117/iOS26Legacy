//
//  iOS26Legacy.m
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import "iOS26Legacy.h"

@implementation iOS26Legacy

+ (BOOL)enable {
    if (@available(iOS 26.0, *)) {
        NSNumber *plistConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIDesignRequiresCompatibility"];
        if (!plistConfig || plistConfig.boolValue == NO) {
            return YES;
        }
    }
    return NO;
}

@end
