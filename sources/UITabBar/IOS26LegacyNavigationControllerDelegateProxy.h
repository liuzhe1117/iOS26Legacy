//
//  IOS26LegacyNavigationControllerDelegateProxy.h
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOS26LegacyNavigationControllerDelegateProxy : NSObject <UINavigationControllerDelegate>

@property (nonatomic, weak, readwrite, nullable) id<UINavigationControllerDelegate> forwardedDelegate;

@end

NS_ASSUME_NONNULL_END
