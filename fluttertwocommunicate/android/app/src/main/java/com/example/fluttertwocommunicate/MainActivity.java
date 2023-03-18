package com.example.fluttertwocommunicate;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "https://www.jianshu.com/p/ce7ed8bbf35c";

    private static final String NativeToFlutterChannel = "https://www.jianshu.com/p/7dbbd3b4ce32";

    int _nativeCount = 0;

    //安卓原生方法传参，每1s就会被执行一次实现自增
    private void repeatCount(EventChannel.EventSink eventSink) {
        _nativeCount++;

        //需要在主线程中执行传值至flutter
        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> eventSink.success(_nativeCount));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));

        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("callNativeMethond")) {

                Object para = call.arguments;
                System.out.println("flutter传给安卓的值：" + para);

                String nativeFinalStr = "原生再返回给flutter的值";

                result.success(nativeFinalStr);

                //处理错误可以在这抛出异常
                //result.error("001", "安卓进入异常", "进入flutter的trycatch方法的catch方法");
            } else {
                result.notImplemented();
            }
        });

        //注册监听通道
        new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), NativeToFlutterChannel).setStreamHandler(
                new EventChannel.StreamHandler() {
                    Timer timer = new Timer();

                    @Override
                    //注册成功后的回调
                    public void onListen(Object o, EventChannel.EventSink eventSink) {
                        //定时器自增数值然后传参
                        timer.schedule(new TimerTask() {
                            @Override
                            public void run() {
                                repeatCount(eventSink);
                            }
                        }, 0, 1000);
                    }

                    @Override
                    public void onCancel(Object o) {
                        timer = null;
                    }
                }
        );
    }

    //注册插件
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        //添加插件
        flutterEngine.getPlugins().add(new NVPlugin());
    }
}
