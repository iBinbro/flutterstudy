#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "NVPlatformViewFactory.h"

//遵循代理方法
@interface AppDelegate()<FlutterStreamHandler>

@end

@implementation AppDelegate{
    /// 用于主动传值给flutter的桥梁.
    FlutterEventSink _eventSink;
    NSInteger _nativeCount;
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
    
    /**********原生主动传值给flutter-Start**********/
    _nativeCount = 0;
    
    NSLog(@"原生实现 原生传值给flutter的通道标识");
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"https://www.jianshu.com/p/7dbbd3b4ce32" binaryMessenger:controller.binaryMessenger];
    //设置代理
    [eventChannel setStreamHandler:self];
    
    /**********原生主动传值给flutter-End**********/
    
    
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    /**********flutter显示原生组件flutter-Start**********/
    NVPlatformViewFactory *nvPlatformViewFactory = [[NVPlatformViewFactory alloc] init];
    //native:插件名，和其他插件区分开 唯一性
    //nvview:flutter中UiKitView组件需要的viewType属性 这样flutter就能找到viewFactory工厂方法返回对应的原生组件
    [[self registrarForPlugin:@"native"] registerViewFactory:nvPlatformViewFactory withId:@"nvview"];
    /**********flutter显示原生组件flutter-End**********/
    
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

/**********原生主动传值给flutter-Start**********/
//flutter开始进行监听，并在此方法传入 原生主动传值给flutter的桥梁 event
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    NSLog(@"flutter开始进行监听，并在此方法传入 原生主动传值给flutter的桥梁 event");
    _eventSink = events;
    
    [self repeatAddNativeCount];
    
    return nil;
}

//翻了下官方文档 Invoked when the last listener is deregistered from the Stream associated to this channel on the Flutter side. 大致意思是stream关联的这个通道监听器取消后调用,找了下flutter的dart代码，没取消监听的方法 后面再说吧 待解
- (FlutterError *)onCancelWithArguments:(id)arguments{
    _eventSink = nil;
    return nil;
}

- (void)repeatAddNativeCount{
    NSLog(@"重复传值执行");
    _nativeCount++;
    //通过桥梁传值
    if (_eventSink) {
        _eventSink(@(_nativeCount));
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self repeatAddNativeCount];
    });
}

/**********原生主动传值给flutter-Start**********/

@end
