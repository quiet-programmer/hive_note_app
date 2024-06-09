import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/message_dialog.dart';

class GetRequest {
  static Future makeGetRequest({
    String? requestEnd,
    Map<String, dynamic>? queryParams,
    String? outApiUrl,
    String? bearer,
    BuildContext? context,
  }) async {
    final userModel = HiveManager().userModelBox;
    try {
      final Uri url = Uri.parse('${outApiUrl ?? apiUrl}/$requestEnd');
      final Uri finalUri = url.replace(queryParameters: queryParams);

      var response = await http.get(
        finalUri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $bearer',
        },
      ).timeout(const Duration(seconds: 20)); // Set a timeout of 10 seconds

      var status = json.decode(response.body)['status'];
      var errorMsg = json.decode(response.body)['message'];

      if (status == 401) {
        showError('$errorMsg');
        userModel.delete(tokenKey);
      }

      if (status == 400 || status == 500) {
        showError('$errorMsg');
      }

      return json.decode(response.body);
    } on TimeoutException catch (e) {
      // Handle timeout exception
      showError('Request timed out after 10 seconds.');
      return null;
    } on FormatException catch (e) {
      logger.i(e.toString());
      if (e.toString().contains('Unexpected character')) {
        showError('Your Session has expired.');
      }
      return null;
    } catch (e) {
      logger.e(e);
      if (e.toString().contains('Connection timed out')) {
        showError('Connection timed out');
      } else if (e.toString().contains('Connection closed')) {
        showError('Connection closed!!!');
      } else if (e.toString().contains('Connection reset by peer')) {
        showError('Connection reset by peer');
      } else {
        showError('Something went wrong');
      }
      return null;
    }
  }
}