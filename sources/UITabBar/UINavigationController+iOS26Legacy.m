//
//  UINavigationController+iOS26Legacy.m
//  iOS26Legacy
//
//  Created by liuzhe1117 on 2025/12/16.
//  Copyright © 2025 liuzhe1117. All rights reserved.
//

#import "UINavigationController+iOS26Legacy.h"
#import "iOS26Legacy.h"
#import "IOS26LegacyNavigationControllerDelegateProxy.h"
#import "UIViewController+iOS26Legacy.h"
#import <RSSwizzle/RSSwizzle.h>
#import <objc/runtime.h>

static const void *kDelegateProxyKey = &kDelegateProxyKey;

@implementation UINavigationController (iOS26Legacy)

+ (void)load {
    if (![iOS26Legacy enable]) {
        return;
    }
    
    RSSwizzleInstanceMethod(UINavigationController.class,
                            @selector(setDelegate:),
                            RSSWReturnType(void),
                            RSSWArguments(id<UINavigationControllerDelegate> delegate),
                            RSSWReplacement({
        IOS26LegacyNavigationControllerDelegateProxy *proxy = [self getOrCreateDelegateProxy];
        if (delegate == proxy) {
            RSSWCallOriginal(delegate);
            return;
        }
        proxy.forwardedDelegate = delegate;
        RSSWCallOriginal(proxy);
    }), RSSwizzleModeAlways, nil);

    RSSwizzleInstanceMethod(UINavigationController.class,
                            @selector(viewDidLoad),
                            RSSWReturnType(void),
                            RSSWArguments(),
                            RSSWReplacement({
        [self installDelegateProxy];
        RSSWCallOriginal();
    }), RSSwizzleModeAlways, nil);
}

#pragma mark - delegate proxy

- (IOS26LegacyNavigationControllerDelegateProxy *)delegateProxy {
    return objc_getAssociatedObject(self, kDelegateProxyKey);
}

- (void)setDelegateProxy:(IOS26LegacyNavigationControllerDelegateProxy *)delegateProxy {
    objc_setAssociatedObject(self, kDelegateProxyKey, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IOS26LegacyNavigationControllerDelegateProxy *)getOrCreateDelegateProxy {
    IOS26LegacyNavigationControllerDelegateProxy *delegateProxy = [self delegateProxy];
    if (delegateProxy != nil) {
        return delegateProxy;
    }
    delegateProxy = [IOS26LegacyNavigationControllerDelegateProxy new];
    [self setDelegateProxy:delegateProxy];
    return delegateProxy;
}

- (void)installDelegateProxy {
    IOS26LegacyNavigationControllerDelegateProxy *proxy = [self getOrCreateDelegateProxy];
    id<UINavigationControllerDelegate> existingDelegate = self.delegate;
    if (existingDelegate == proxy) {
        return;
    }
    proxy.forwardedDelegate = existingDelegate;
    [self setDelegate:proxy];
}

#pragma mark - private

- (void)changeTabbarStatusIfNeeded {
    UITabBarController *rootTabBarController = [self rootTabBarController];
    if (rootTabBarController == nil) {
        return;
    }

    if (![self isDirectChildOfRootTabBarController:rootTabBarController]) {
        return;
    }

    BOOL shouldTabBarHidden = [self shouldTabBarHidden];
    BOOL currentTabbarHidden = rootTabBarController.tabBar.hidden;

    if (shouldTabBarHidden && !currentTabbarHidden) {
        [self hideTabbar];
    } else if (!shouldTabBarHidden && currentTabbarHidden) {
        [self showTabbar];
    }
}

- (BOOL)shouldTabBarHidden {

    if (self.viewControllers.count <= 1) {
        return NO;
    }

    NSArray<UIViewController *> *pushedViewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(1, self.viewControllers.count - 1)];
    for (UIViewController *viewController in pushedViewControllers) {
        if ([viewController customHidesBottomBarWhenPushed]) {
            return YES;
        }
    }
    return NO;
}

- (void)hideTabbar {
    [self updateTabbarWithShouldHidden:YES];

    if (self.transitionCoordinator) {
        UIImageView *tabbarImageView = [self imageViewFromSnapshotOfView:self.rootTabBarController.tabBar];
        UIViewController *fromVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        [fromVC.view addSubview:tabbarImageView];

        [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [tabbarImageView removeFromSuperview];
            if (context.isCancelled) {
                [self updateTabbarWithShouldHidden:NO];
            }
        }];
    }
}

- (void)showTabbar {
    if (self.transitionCoordinator) {
        UIImageView *tabbarImageView = [self imageViewFromSnapshotOfView:self.rootTabBarController.tabBar];
        UIViewController *toVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [toVC.view addSubview:tabbarImageView];

        [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [tabbarImageView removeFromSuperview];
            if (context.isCancelled) {

            } else {
                [self updateTabbarWithShouldHidden:NO];
            }
        }];
    } else {
        [self updateTabbarWithShouldHidden:NO];
    }
}

#pragma mark - helper

- (UITabBarController *)rootTabBarController {
    UIWindowScene *activeScene = nil;
    for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            activeScene = scene;
            break;
        }
    }

    if (activeScene == nil) {
        return nil;
    }

    UIWindow *keyWindow = activeScene.keyWindow;
    UIViewController *rootVC = keyWindow.rootViewController;

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)rootVC;
    }
    return nil;
}

- (BOOL)isDirectChildOfRootTabBarController:(UITabBarController *)rootTabBarController {
    for (UIViewController *childViewController in rootTabBarController.viewControllers) {
        if (childViewController == self) {
            return YES;
        }
    }
    return NO;
}

- (UIImageView *)imageViewFromSnapshotOfView:(UIView *)view {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithBounds:view.bounds];
    UIImage *snapshot = [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        [view.layer renderInContext:context.CGContext];
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:snapshot];
    imageView.frame = view.frame;

    return imageView;
}

- (void)updateTabbarWithShouldHidden:(BOOL)shouldHidden {
    self.rootTabBarController.tabBar.hidden = shouldHidden;
}

@end
