import 'package:dark_pattern_detector/utils/snakbar.dart';
import 'package:dark_pattern_detector/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

class SmsReceiver extends StatefulWidget {
  const SmsReceiver({Key? key}) : super(key: key);

  @override
  State<SmsReceiver> createState() => _SmsReceiverState();
}

class _SmsReceiverState extends State<SmsReceiver> {
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    listenToIncomingSms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Your widget UI
        );
  }

  Future<bool> requestSmsPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      final result = await Permission.sms.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  void onSmsReceived(SmsMessage message) {
    final urlPattern = RegExp(
        r'(http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+)');
    final matches = urlPattern.allMatches(message.body ?? "");

    if (matches.isNotEmpty) {
      // Assuming you want to open the first URL found in the SMS
      String url = matches.first.group(0) ?? "";
      if (url.isNotEmpty) {
        // You can use the URL for whatever you need; for example, opening it
        Utils().toastMessage(url, Colors.black, 3);
      }
    }
  }

  Future<void> listenToIncomingSms() async {
    if (await requestSmsPermission()) {
      telephony.listenIncomingSms(
        onNewMessage: onSmsReceived,
        onBackgroundMessage:
            _onBackgroundMessage, // Use a top-level or static function here
      );
    }
  }

  static Future<void> _onBackgroundMessage(SmsMessage message) async {
    // Handle background message logic here
    Utils().toastMessage('MESSAGE RECIVED', Colors.black, 3);
  }
}
