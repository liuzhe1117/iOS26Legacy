# iOS26Legacy

[English](./README.md) | [中文](./README.zh.md)

iOS26Legacy 是一个用于适配 iOS 26 行为变化的 UIKit 兼容性 Pod。目标是令 iOS 26 上的系统UI组件可以表现得与低版本一致。
- 通过OC方法交换技术，实现无侵入式适配，只需源码引入本pod即可
- 依赖RSSwizzle
- 仅供交流学习使用

## 功能说明

以下所有逻辑仅在 `+[iOS26Legacy enable]` 返回 `YES` 时生效。

### UIScrollView

- 实现：关闭 iOS 26 新增的滚动边缘视觉效果
- 原理：
    - hook `[UIScrollEdgeEffect isHidden]` 为YES

### UINavigationBar

- 实现：关闭 iOS 26 新增的按钮背景视觉效果
- 原理：
    - hook `[UIBarButtonItem hidesSharedBackground]` 为YES
    - hook `[UIBarButtonItem sharesBackground]` 为NO

### UITabBar

- 实现：关闭 iOS 26 新增的液态玻璃交互
- 原理：
    - hook `[UITabBar addSubview:]` ，将系统添加的 `_UITabBarPlatterView` 设为隐藏
    - hook `[UITabBar addGestureRecognizer:]` ，将系统添加的 `_UIContinuousSelectionGestureRecognizer` 设为disable

- 实现：还原低版本hidesBottomBarWhenPushed系统动画行为
- 原理：
    - hook `[UITabBar hidesBottomBarWhenPushed]`，返回NO
    - hook `[UITabBar setHidesBottomBarWhenPushed:]`，记录设置并通过添加 `[UITabBar customHidesBottomBarWhenPushed]`返回
    - 在 `UINavigationControllerDelegate` 的 `willShowViewController:` 时，插入自定义tabbar转场。将tabbar截图后贴在fromVC或toVC实现。
        - hook `[UINavigationController setDelegate:]`
        - hook `[UINavigationController viewDidLoad]`

## Pod 结构

- `base`：总开关
- `UIScrollView`：UIScrollView兼容
- `UINavigationBar`：UINavigationBar兼容
- `UITabBar`：UITabBar兼容

默认安装包含全部 subspec。

## 安装方式

在 Podfile 中添加：

```ruby
pod 'iOS26Legacy'
```

或指定 subspec：

```ruby
pod 'iOS26Legacy', :subspecs => ['UITabBar']
```

## Author

liuzhe1117

## License

iOS26Legacy 基于 MIT 协议发布，详见 `LICENSE` 文件。
