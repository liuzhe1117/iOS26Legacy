# iOS26Legacy

[English](./README.en.md) | [中文](./README.md)

iOS26Legacy is a UIKit compatibility pod for iOS 26 behavior changes.  
Its goal is to make UIKit components on iOS 26 behave closer to older system versions.

- Uses Objective-C method swizzling for non-invasive adaptation.
- Depends on RSSwizzle.
- For communication and learning only.

## What It Does

All hooks are enabled only when `+[iOS26Legacy enable]` returns `YES`.

### UIScrollView

- Behavior: disables the new scroll-edge visual effect introduced by iOS 26.
- Mechanism:
  - hooks `[UIScrollEdgeEffect isHidden]` to return `YES`.

### UINavigationBar

- Behavior: disables the new button background visual effect introduced by iOS 26.
- Mechanism:
  - hooks `[UIBarButtonItem hidesSharedBackground]` to return `YES`.
  - hooks `[UIBarButtonItem sharesBackground]` to return `NO`.

### UITabBar

- Behavior: disables the new liquid-glass interaction introduced by iOS 26.
- Mechanism:
  - hooks `[UITabBar addSubview:]` and hides system-added `_UITabBarPlatterView`.
  - hooks `[UITabBar addGestureRecognizer:]` and disables system-added `_UIContinuousSelectionGestureRecognizer`.

- Behavior: restores older transition behavior around `hidesBottomBarWhenPushed`.
- Mechanism:
  - hooks `[UIViewController hidesBottomBarWhenPushed]` to return `NO`.
  - hooks `[UIViewController setHidesBottomBarWhenPushed:]` to store external values and exposes `[UIViewController customHidesBottomBarWhenPushed]`.
  - inserts custom tab bar transition in `UINavigationControllerDelegate` `willShowViewController:`.
    - hooks `[UINavigationController setDelegate:]`.
    - hooks `[UINavigationController viewDidLoad]`.

## Pod Structure

- `base`: main switch
- `UIScrollView`: UIScrollView compatibility
- `UINavigationBar`: UINavigationBar compatibility
- `UITabBar`: UITabBar compatibility

Default install includes all subspecs.

## Installation

Add this to your Podfile:

```ruby
pod 'iOS26Legacy'
```

Or choose subspecs:

```ruby
pod 'iOS26Legacy', :subspecs => ['UITabBar']
```

## Author

liuzhe1117

## License

iOS26Legacy is available under the MIT license. See the LICENSE file for more info.
