//
//  NVPlatformViewFactory.m
//  Runner
//
//  Created by qujian001 on 17.03.2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

#import "NVPlatformViewFactory.h"

/// 原生的组件
@interface NVView : UIView
@end

@implementation NVView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = UIColor.greenColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
        label.backgroundColor = UIColor.purpleColor;
        label.text = @"我是原生组件";
        [self addSubview:label];
    }
    return self;
}
- (void)dealloc{
    NSLog(@"原生组件销毁释放这里会被调用 实验证明 flutter侧页面关闭后这里会调用 dealloc 所以是自动释放的");
}
@end

@interface AnotherView : UIView
@end

@implementation AnotherView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = UIColor.blueColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
        label.backgroundColor = UIColor.yellowColor;
        label.text = @"我是另一个原生组件";
        [self addSubview:label];
    }
    return self;
}
- (void)dealloc{
    NSLog(@"原生组件销毁释放这里会被调用 实验证明 flutter侧页面关闭后这里会调用 dealloc 所以是自动释放的");
}
@end




/// 一个实现FlutterPlatformView协议的基类(NSObject<FlutterPlatformView>)
@interface NVViewObject : NSObject<FlutterPlatformView>

/// 新声明一个方法存放flutter侧传过来的参数
@property NSNumber* argpara;
- (instancetype)initWithArg:(NSNumber*)arg;

@end

@implementation NVViewObject

- (instancetype)initWithArg:(NSNumber*)arg{
    if (self = [super init]){
        self.argpara = arg;
    }
    return self;
}

/// 实现协议方法<FlutterPlatformViewFactory>
/// 这里返回原生组件
/// 返回的原生组件大小是撑满flutter侧的大小的 这里设置了frame也不会起作用
- (nonnull UIView *)view {
    if (self.argpara.intValue == 1){
//        return [[NVView alloc]  initWithFrame:CGRectMake(0, 0, 10, 10)];
        return [[NVView alloc] init];
    }else{
//        return [[AnotherView alloc]  initWithFrame:CGRectMake(0, 0, 10, 10)];
        return [[AnotherView alloc] init];
    }
}

@end

@implementation NVPlatformViewFactory

/// 与flutter中 creationParams creationParamsCodec 对应 不实现此方法args则为null
- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterJSONMessageCodec sharedInstance];
}

/// 实现协议方法<FlutterPlatformViewFactory>
/// 这里需要返回一个实现FlutterPlatformView协议的基类(NSObject<FlutterPlatformView>)
/// viewId是自动生成的无法指定
/// args flutter侧传递的参数
- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    NSLog(@"frame = %@",NSStringFromCGRect(frame));
    NSLog(@"viewId = %lld args = %@",viewId, args);
    
    //args 根据这个参数可以返回不同的view
    return [[NVViewObject alloc] initWithArg:args];
}

@end
