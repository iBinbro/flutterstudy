package com.example.fluttertwocommunicate;

import android.os.Bundle;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "https://www.jianshu.com/u/ee3db73e5459";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("callNativeMethond")) {

                    Object para = call.arguments;
                    System.out.println("flutter传给安卓的值：" + para);

                    String nativeFinalStr = "返回给原生安卓的值";

                    result.success(nativeFinalStr);

                    result.error("001", "安卓进入异常", "进入flutter的trycatch方法的catch方法");

                } else {
                    result.notImplemented();
                }
            }
        });
    }
}
