import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "flutter-chatt-app-bb371",
          "private_key_id": "b89670fe0ce60d528dfc60235388c74151dc6278",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCTSp+i4KsdwecM\nax/uR62OBRAURBZAthNwKquYqPbJXMMjqjxS6dNH/WCGKRdryDfQu1y8hqb6rYgW\nz/CBzuo+fahHkx22ASwZ5mcClQsQClpYXGcYMmesCX9gTjgpQiXTl2dY0qTY2S28\n+Tff2EeguvYuQXeKwj8CQ668ucE2jFlQdQDqGxpR/S7BnuxQIZRGNRrcNhbcQjqp\np35vmi86p6hSzW4A4bbXkbZQopWLrqXRPc9CYJOyhfp+IWPJUgzOsk8eZBl5AmSz\nLb8aN+GKH+gCEAMtQRxtGRObhoxsUfHrNKoV+6n9Ktk7GDJwJL2L/XE/zrUSYLuj\nRDF+yncxAgMBAAECggEAAoyW1TSSuZXeyBP9jjvu2MelJtij0vRjwzv10tNPzB3f\nIbmjSCMUXUlZF5FT/rFNJ/9qJDgnYSzKL2zjYnfAjZrSpAR7jegYyYz3iO+n7Jvl\nQuS8gwpySWOzsOjBp5MlwPL8nqisojUmCcB9c1IUsUczFgtbhIsGmKUvu8PyQF2o\nQCNdLRpzaWVP6zeTmiPcdxQWX4R2bNhWWFJD6EAC0OXWOZRZ391Is6v470SrCHFh\nnKGH2APeVpwCjobPm5yW1/y/dAOwgVPmc3b4FmOLlKdKLWickzEWbwwt7j7zEhQ3\ncvAMpc5PP6ugMjf7HeTyWBRkvJGyrVh0cVAyMVC4fQKBgQDFSTf1/C7gAiHxkOyQ\ntjGXsqECJX1wadFOZ9LwHQhdvFIDa37WbL6g9dxmJc83mOXpAH1r5iCp6giqqSMl\nzT9unHD7XWI6exx/+GjAAE9QD76zqa1aPoTN+x3dOzYmcHDmgzRkVrHbeWtkfBQ7\nDAUnzI+ZyzUDNHqsUbucKCtMrQKBgQC/IG8/EsvHsOnINvX+5xQhmthwJhW1N6S8\nCNDzGBNMdsuoTtRi1EGnISWhlzHeAgnIfhz8tonACJ9a4g6hpglf1FfpG6Zm2/OZ\nJo8nwl0JR6Bh1d2dEj8gp3JUlJcyWUEEX+7C7i/lM7WOLChlyVXeTeel7Dxs2WlL\nsGizsUKBFQKBgDUx6+Pozp7aFFr1T8QpTC/yG1Xf0/Xmomg4uHjD60iTCa4gYv/g\nLHpsMLReR4RfNsbfufHJCE+oahPSLUb5E7x4dEJiyKSqI2IiEeSLcNdOl4YMH1Dx\nAJAlwMSxPYWZ1edhw1O2yJg8IgfjKPVO5Wj40FOQpkep89XY5/RQJHS1AoGBAL0x\ndC3xgzs3SxRgI36ia/EgAORzLsXmQPHJoF0jFed5KPyAnAkAp8SzMTcWHczwI5MO\nE8+tOgqX/nbOk0E8xMbRwfwE3OGxFSAjZU4sPkBzYLW4KNnVOBww5SIIvOqgI5Yb\nCJR5h3vRhgUofQzVEmUupQJAKUhupqbAB8To0TZJAoGAecQbRN7jZ1WFKGfVUJjC\nxQuLwfVngw8lWvubejB+uV2HavJunH7asmZ2bxgt1CxgweCBLKxhk+F+yoIQvgH7\nD+4qn/VrDOwiBBTXhymhSodPBTho9MUcqRNouVuP0q/UTy3CAmshT+cqBLODuuIM\n/FzDJ6JL31PrUb0LGLVORoY=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@flutter-chatt-app-bb371.iam.gserviceaccount.com",
          "client_id": "101014615588482733608",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40flutter-chatt-app-bb371.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
