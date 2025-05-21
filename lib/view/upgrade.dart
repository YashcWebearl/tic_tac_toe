import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import '../Widget/bg_container.dart';
import '../Widget/sound.dart';
import '../Widget/upgrade_card.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {

  String environment = "PRODUCTION";
  String appId = ""; // Add your app ID here
  String merchantId = "M22TYL06SCE61";
  String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool enableLogging = true;
  late String checksum;
  String saltKey = "aa6f3137-1163-40da-aef6-558e86ee6450";
  String saltIndex = "1";
  String callBackUrl =
      "https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1";
  late String body;
  String apiEndPoint = "/pg/v1/pay";
  Object? result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phonepeInit();
  }
  String getChecksum(String amount) {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "MUID123",
      "amount": 1 * 100, // Convert to paise
      "callbackUrl": callBackUrl,
      "mobileNumber": "9999999999",
      "paymentInstrument": {
        "type": "PAY_PAGE",
      }
    };
    String base64body = base64.encode(utf8.encode(json.encode(requestData)));
    checksum =
    "${sha256.convert(utf8.encode(base64body + apiEndPoint + saltKey)).toString()}###$saltIndex";
    return base64body;
  }
  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
        print(result);
      });
    }).catchError((error) {
      handleError(error);
    });
  }

  String paisa="1";

  void startPgTransaction() async {
    final amount = paisa;
    if (amount.isEmpty ||
        int.tryParse(amount) == null ||
        int.parse(amount) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid amount");
      return;
    }

    body = getChecksum(amount);
    print("Request Body: $body");
    print("Checksum: $checksum");
    print("Callback URL: $callBackUrl");

    try {
      final response = await PhonePePaymentSdk.startTransaction(
        body,
        callBackUrl,
        checksum,
        "",
      );

      if (response != null) {
        print("Response: $response");

        if (response.containsKey('error')) {
          String error = response['error'];
          result = "Flow Completed - Error: $error";
        } else if (response.containsKey('status')) {
          String status = response['status'];
          if (status == 'SUCCESS') {
            result = "Flow Completed - Status: Success!";
            await checkStatus();
          } else {
            result = "Flow Completed - Status: $status";
          }
        } else {
          result = "Unexpected Response Structure";
        }
      } else {
        result = "Flow Incomplete";
      }
    } catch (error) {
      handleError(error);
    }

    // Call setState outside the async operation
    if (mounted) {
      setState(() {});
    }
  }
  void handleError(error) {
    print("Error: $error");
    setState(() {
      result = {"error": error};
    });
    Fluttertoast.showToast(msg: "Error: $error");
  }
  Future<void> checkStatus() async {
    String url =
        "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId";
    String concatString = "/pg/v1/status/$merchantId/$transactionId$saltKey";
    var bytes = utf8.encode(concatString);
    var digest = sha256.convert(bytes).toString();
    String xVerify = "$digest###$saltIndex";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-VERIFY": xVerify,
      "X-MERCHANT-ID": merchantId
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      final res = jsonDecode(response.body);

      print("Response: $res"); // Debug statement to print the response

      if (res["success"] == true &&
          res["code"] == "PAYMENT_SUCCESS" &&
          res["data"]["state"] == "COMPLETED") {
        print("Success Response: $res");
        Fluttertoast.showToast(msg: res['message']);
      } else {
        print("Failure Response: $res");
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    } catch (error) {
      print("Error in checkStatus: $error");
      Fluttertoast.showToast(msg: "Error in checkStatus: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    print('upgrade.dart');
    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Top-right cancel icon
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildRoundedIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 16),
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: GestureDetector(
            //       onTap: () {
            //         Navigator.pop(context); // Pops back to StartScreen
            //       },
            //       child: const Icon(
            //         Icons.close,
            //         size: 28,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children:  [
                  PackageCard(
                    title: "Free Package",
                    price: "",
                    imagePath: "assets/free.png",
                    isFree: true,
                  ),
                  GestureDetector(
                    onTap: (){
                      startPgTransaction();
                    },
                    child: PackageCard(
                      title: "Prime Package",
                      price: "\$22",
                      imagePath: "assets/preimium.png",
                      isFree: false,
                      isPrime: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRoundedIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        AudioHelper().playButtonClick();
        onTap();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF400CB9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
