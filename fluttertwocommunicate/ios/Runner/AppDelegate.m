#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    __weak __typeof(self) weakself = self;
    
    FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
    
    //通道标识，要和flutter端的保持一致
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"https://www.jianshu.com/u/ee3db73e5459" binaryMessenger:controller];
    
    //flutter端通过通道调用原生方法时会进入以下回调
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //call的属性method是flutter调用原生方法的方法名，我们进行字符串判断然后写入不同的逻辑
        if ([call.method isEqualToString:@"callNativeMethond"]) {
            
            //flutter传给原生的参数
            id para = call.arguments;
            
            NSLog(@"flutter传给原生的参数：%@", para);
            
            //获取一个字符串
            NSString *nativeFinalStr = [weakself getString];
            
//            if (nativeFinalStr!=nil) {
//                //把获取到的字符串传值给flutter
//                result(nativeFinalStr);
//            }else{
//                //异常(比如改方法是调用原生的getString获取一个字符串，但是返回的是nil(空值)，这显然是不对的，就可以向flutter抛出异常 进入catch处理)
//                result([FlutterError errorWithCode:@"001" message:[NSString stringWithFormat:@"进入异常处理"] details:@"进入flutter的trycatch方法的catch方法"]);
//            }
        }else{
            //调用的方法原生没有对应的处理  抛出未实现的异常
            result(FlutterMethodNotImplemented);
        }
    }];
    
    
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//返回一个字符串
- (NSString *)getString{
//    return nil;//返回nil进入异常的情景
    return @"原生传给flutter的值";
}

@end
