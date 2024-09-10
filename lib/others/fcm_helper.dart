import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class FcmHelper {

  // send notification


  Future<bool> sendPushMessage({
    required String recipientToken,
    required String title,
    required String body,
  }) async {
    final jsonCredentials = await rootBundle.loadString('assets/json/account.json');
    final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    // Use the correct scope for FCM
    final client = await auth.clientViaServiceAccount(
      creds,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    // Notification data
    final notificationData = {
      'message': {
        'token': recipientToken,
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };

    // Replace this with your Firebase Project ID, not the sender ID
    const String projectId = 'rimberio-296b9';

    // Send the POST request to FCM
    final response = await client.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken.data}',  // Add the access token here
      },
      body: jsonEncode(notificationData),
    );

    client.close();

    if (response.statusCode == 200) {
      return true; // Success
    }

    print("Notification Sending Error Response status: ${response.statusCode}");
    print("Error response body: ${response.body}");  // Print the response body for more error details
    return false;
  }

}
