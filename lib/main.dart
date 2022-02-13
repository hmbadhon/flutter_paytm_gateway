import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PayTm Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PayTm Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String mid = "mid_id",
      orderId = "order_id",
      amount = "amount",
      txnToken = "txn_token";
  String result = "";
  bool isStaging = true;
  bool isApiCallInProgress = false;
  String callbackUrl = "";
  bool restrictAppInvoke = false;
  bool enableAssist = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _startTransaction();
          },
          child: const Text('PayTm Pay'),
        ),
      ),
    );
  }

  Future<void> _startTransaction() async {
    if (txnToken.isEmpty) {
      return;
    }
    var sendMap = <String, dynamic>{
      "mid": mid,
      "orderId": orderId,
      "amount": amount,
      "txnToken": txnToken,
      "callbackUrl": callbackUrl,
      "isStaging": isStaging,
      "restrictAppInvoke": restrictAppInvoke,
      "enableAssist": enableAssist
    };
    log(sendMap.toString());
    try {
      var response = AllInOneSdk.startTransaction(mid, orderId, amount,
          txnToken, "", isStaging, restrictAppInvoke, enableAssist);
      response.then((value) {
        log(value.toString());
        setState(() {
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          setState(() {
            result = onError.message.toString() +
                " \n  " +
                onError.details.toString();
          });
        } else {
          setState(() {
            result = onError.toString();
          });
        }
      });
    } catch (err) {
      result = err.toString();
    }
  }
}
