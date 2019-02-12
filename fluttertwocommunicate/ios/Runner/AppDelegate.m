#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate{
    /// 用于主动传值给flutter的桥梁.
    FlutterEventSink _eventSink;
    NSInteger _nativeCount;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    __weak __typeof(self) weakself = self;
    
    FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
    
    
    
    /***********flutter主动调用原生-Start*********/
    //通道标识，要和flutter端的保持一致
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"https://www.jianshu.com/p/ce7ed8bbf35c" binaryMessenger:controller];
    
    //flutter端通过通道调用原生方法时会进入以下回调
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //call的属性method是flutter调用原生方法的方法名，我们进行字符串判断然后写入不同的逻辑
        if ([call.method isEqualToString:@"callNativeMethond"]) {
            
            //flutter传给原生的参数
            id para = call.arguments;
            
            NSLog(@"flutter传给原生的参数：%@", para);
            
            //获取一个字符串
            NSString *nativeFinalStr = [weakself getString];
            
            if (nativeFinalStr!=nil) {
                //把获取到的字符串传值给flutter
                result(nativeFinalStr);
            }else{
                //异常(比如改方法是调用原生的getString获取一个字符串，但是返回的是nil(空值)，这显然是不对的，就可以向flutter抛出异常 进入catch处理)
                result([FlutterError errorWithCode:@"001" message:[NSString stringWithFormat:@"进入异常处理"] details:@"进入flutter的trycatch方法的catch方法"]);
            }
        }else{
            //调用的方法原生没有对应的处理  抛出未实现的异常
            result(FlutterMethodNotImplemented);
        }
    }];
    /**********flutter主动调用原生-End**********/
    
    
    
    
    
    
    
    /**********原生主动传值给flutter-Start**********/
    _nativeCount = 0;
    
    NSLog(@"原生实现 原生传值给flutter的通道标识");
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"https://www.jianshu.com/p/7dbbd3b4ce32" binaryMessenger:controller];
    [eventChannel setStreamHandler:self];
    
    /**********原生主动传值给flutter-End**********/
    
    
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//返回一个字符串
- (NSString *)getString{
//    return nil;//返回nil进入异常的情景
    return @"原生传给flutter的值";
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
    if (_eventSink) {
        _eventSink(@(_nativeCount));
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self repeatAddNativeCount];
    });
}

/**********原生主动传值给flutter-Start**********/

@end
