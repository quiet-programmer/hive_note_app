import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/auth/verify_code.dart';
import 'package:note_app/app/router/route_name.dart';
import 'package:note_app/m_functions/navigate_to.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/message_dialog.dart';

class PostRequest {
  static Future makePostRequest({
    String? requestEnd,
    String? bearer,
    String? vEmail,
    dynamic jsonParam,
    Map<String?, String?>? params,
    BuildContext? context,
  }) async {
    final userModel = HiveManager().userModelBox;
    var url = Uri.decodeFull('$apiUrl/$requestEnd');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: params,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $bearer',
        },
      ).timeout(const Duration(seconds: 20));

      var status = json.decode(response.body)['status'];
      var errorMsg = json.decode(response.body)['message'];

      if(status == 403) {
        navigateTo(context!, destination: VerifyCode(email: vEmail));
        showError('$errorMsg');
      }

      if (status == 401) {
        clearAndNavigate(context!, path: RouteName.login_screen);
        userModel.delete(tokenKey);
        logger.i(errorMsg);
        showError('$errorMsg');
      }

      if (status != 200 && status != 201 && status != 202) {
        logger.i(errorMsg);
        showError('$errorMsg');
      }

      return json.decode(response.body);
    } on TimeoutException catch (e) {
      // Handle timeout exception
      showError('Request timed out after 10 seconds.');
      return null;
    } on FormatException catch (e) {
      if (e.toString().contains('Unexpected character')) {
        showError('Something Unexpected just happened');
      }
      return null;
    } on NoSuchMethodError catch (e) {
      if (e.toString().contains('NoSuchMethodError')) {
        showError('Something Unexpected just happened');
      }
      return null;
    }  catch (e) {
      logger.e(e);
      return null;
    }
  }
}