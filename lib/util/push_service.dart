import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/firestore/v1.dart' as firestore;

class PushService {
  PushService._();
  static const String _url = 'https://fcm.googleapis.com/v1/projects/myfriend-7ca89/messages:send';

  static Future<void> push(String? token, String title, String body) async {
    if (token == null) {
      return;
    }

    final message = {
      "message": {
        "token": token,
        "notification": {
          "body": body,
          "title": title,
        }
      }
    };

    // Obtain the access token using the method from Step 1
    var accessToken = await getAccessToken();

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {

      // Push notification sent successfully
      print('Push notification sent successfully');
      print('Response: ${response.body}');
    } else {
      // Failed to send push notification
      throw Exception('Failed to send push notification: ${response.body}');
    }
  }

  static Future<String> getAccessToken() async {
    var client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(r'''
      {
      "type": "service_account",
      "project_id": "myfriend-7ca89",
      "private_key_id": "4f5bbafab4d0e18839dc319eb9e0a7a498349b50",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDzRqmrdfTElX4r\n7xpIUx3hqC4LPzyp6fQeXJQjWAm7shGy3n61ffI9xnDJRa5t67iUuiDoa+KMWzB0\nSieOfM1RGuekZicdcCOktWD4/W1LSKLus5o/lbGJZziiQBSwYMC57Tk+P3d/FT8/\nrJQAgSp3r6vzKEfItvxYGmObunqZa1qJwvFSrV9z6uPM+AC8ZsD6Xe0Nv5XRZZe2\n15+DjVJn24advy0m2yDZZlXj0mK2o3o++on4xTKDAAvTzp/ML1eu4pF4qB4iSdk3\n7EMiKUCCO0Fzw7+R+17JbIn0sAoFwHPp1RSvMlMJkfKkkZeKXsixhWLeaqe5LyWN\nMupqwm35AgMBAAECggEAF5KIA71u/XJn0p19PDdTjKdFaOEUgXlSJnP9haw06zs+\npEiTWgYtaAd3q8UE+REvZjff0u2LOuLmH8qEqTWWFm8HNYKRdTSFu6K4lf/GbJZJ\n9VuxTUp1tLTsA6q2Zn3Fhu6BzrKLI2T9Zy/TenYJlaXPwUSsqfnzGx1ZfAA2e3F/\nahYjqfQVyCTJBPKEg7cIf7kCipQla3I1cAFW/JtYF+CI+Td9v71U6lwUsyLkhgCg\nfI7BHl8EIudz02+nCp13V1BxjyOtcHfcewzE9FdJKWPHj9ICwSHi9GVif0Kyn7XV\nRtoNlomrAOfEKGvJczkDfJhsM+lTAv89APSwiU6ntQKBgQD+RufKgumWLYzkM7e5\n1Rqj9KmsJzjOw7M08VOGx5anWi6EfRT1HjtDqg0FscaBmT5VHcPdzgnUynExQTEu\nYAF31u+zAn3/c77XwWtfPPchVze2g8XM/BQEiNrTyiIxChf34COHvfO+bL+A7Cik\nH6zlDV16ymswMHtlqArtAmrzfQKBgQD07KyKDJ4sqIR4kdeN77X3uNs8aXyrRhw2\njy67vla6FNYajrOiKM+62bQJPsqyPqMypb6AV1p2Z/AR/34CdZT82QkoRaNJ4b0q\n7cVFh6OQQAJn5BtQGMPsdRqev5W0Ch9PB9X/C7MqReVCCDuQLMj699w0x++BhM1E\nlr+9Y9v1LQKBgDEoiBtQn9QWzkw362cT2eiknkDX/FWM5BJyLVG7OFb2SlP20pxo\n0dBNCeN18QiRFcnizUEOWjw3PxbkoZtzmBURCpoy+yTtvZF8pUNuR+C8OdshMpZk\njYIq6xNS2rVcXDHhtTzC7mJ8J7HG9jx0mzpVESNyCrLwTIrkp+gWNZMJAoGBAORD\nm76Baf1nBSc1jTaMXQRF9ZWFHpqlme/DXCO/jiaY+r3/ly0fahLTiPZA3jpnJEQ0\nsqn8P6Qw1E6B1lfGbBeG0wEEfd2ClIHo3b0iX+81qMhYkJgCrL64mRmwpn4IHQvT\n2r57kfxo7fSvpYuGIb28uS8701zbf09YS9Tft4T1AoGAJr7C17J0PpQI5ixtQxaW\n0A008sWH6l80JZBJTWD9jrAMmixLX/oxp/dDLAXw4VRG/Vl1zclrF93EIqom3mXL\n3HJGTgKaG2e+Ct2bIfIX0b+fcsCGS7bNP+zt6dPBNv0r96gvjNpBIDa3xTW6hu+k\nU4VYVmjAg7lCEtKzYnnTchw=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-lhsai@myfriend-7ca89.iam.gserviceaccount.com",
      "client_id": "111295786104468105100",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-lhsai@myfriend-7ca89.iam.gserviceaccount.com"
    }
      '''),
      [firestore.FirestoreApi.cloudPlatformScope],
    );

    return client.credentials.accessToken.data;
  }
}
