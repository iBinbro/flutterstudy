import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class TwoCommunicate extends StatefulWidget {
  @override
  _TwoCommunicateState createState() => _TwoCommunicateState();
}

class _TwoCommunicateState extends State<TwoCommunicate> {

  //****************flutter主动调用原生方法****************//
  String _nativeCallBackValue = '等待原生传值';

  //交互的通道名称，flutter和native是通过这个标识符进行相互间的通信
  static const communicateChannel =
      MethodChannel('https://www.jianshu.com/p/ce7ed8bbf35c');

  //异步执行调用原生方法，保持页面不卡住，因为调用原生的方法可能没实现会抛出异常，所以trycatch包住
  Future<void> _communicateFunction(flutterPara) async {
    try {
      //原生方法名为callNativeMethond,flutterPara为flutter调用原生方法传入的参数，await等待方法执行
      final result = await communicateChannel.invokeMethod(
          'callNativeMethond', flutterPara);
      //如果原生方法执行回调传值给flutter，那下面的代码才会被执行
      _nativeCallBackValue = result;

      print('object');
      print('object1');
      print('object2');
    } on PlatformException catch (e) {
      //抛出异常
      //flutter: PlatformException(001, 进入异常处理, 进入flutter的trycatch方法的catch方法)
      print(e);
    }
  }

  //****************原生主动调用flutter****************//
  //存放原生传给flutter的值
  String _nativeToFlutterString = '';

  //注册监听原生通道
  EventChannel eventChannel = EventChannel('https://www.jianshu.com/p/7dbbd3b4ce32');

  //监听到数据后用于处理数据的方法，这个函数是用于处理接收到原生传进来的数据的，可自行定义
  void _receiveFromeNative(Object para){
    print(para);
    setState(() {
      _nativeToFlutterString = para.toString();
    });
  }

  //原生返回错误信息
  void _fromNativeError(Object error){
    print(error);
  }

  @override
  void initState() {
    // TODO: implement initState
    //实现通道的监听，并传入两个带有参数的函数用于监听到数据后 对数据进行处理
    eventChannel.receiveBroadcastStream().listen(_receiveFromeNative, onError: _fromNativeError);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('text'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              MaterialButton(
                color: Colors.blue,
                child: Text(_nativeCallBackValue),
                onPressed: () {
                  _communicateFunction('flutter传值');
                  setState(() {});
                },
              ),

              //显示原生传过来的值
              MaterialButton(
                color: Colors.green,
                child: Text(_nativeToFlutterString),
                onPressed: () {
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
