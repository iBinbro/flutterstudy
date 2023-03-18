package com.example.fluttertwocommunicate;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/// 原生的组件
class NVView extends TextView {
    public NVView(Context context, Object arg) {
        super(context);
        setText("我是安卓原生组件" + arg);
    }
}

/// 一个继承PlatformView类 返回具体的原生组件
class NVPlatformView implements PlatformView {
    Context context;
    Object args;

    NVPlatformView(Context context, Object args) {
        this.context = context;
        this.args = args;
    }

    /// 这里返回原生组件
    @Nullable
    @Override
    public View getView() {
        Log.d("args", "args = " + args);
        return new NVView(context, args);
    }

    @Override
    public void dispose() {
        Log.d("销毁", "NVPlatformView 销毁 自动释放的");
    }
}

/// 工厂类 返回 PlatformView 类实例
class NVPlatformViewFactory extends PlatformViewFactory {

    /// 与flutter中 creationParams creationParamsCodec 对应 不实现此方法args则为null
    public NVPlatformViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        //args 根据这个参数可以返回不同的view
        return new NVPlatformView(context, args);
    }
}

/**********flutter显示原生组件flutter**********/
public class NVPlugin implements FlutterPlugin {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        binding.getPlatformViewRegistry().registerViewFactory("nvview", new NVPlatformViewFactory());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }
}
