import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chirp_up_app/core/errors/app_exceptions.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

class ApiService {
  static bool _isSessionExpiredHandled = false;

  Future<dynamic> getApi(String url) async {
    final token = StorageService.getToken();

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));

      print(response.body);

      return await returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet");
    } on TimeoutException {
      throw RequestTimeoutException("Request Time Out");
    }
  }

  Future<dynamic> postApi(String url, dynamic data) async {
    final token = StorageService.getToken();

    try {
      print(url);
      print(data);

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));

      print(response.body);

      return await returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet");
    } on TimeoutException {
      throw RequestTimeoutException("Request Time Out");
    }
  }

  Future<dynamic> putApi(String url, dynamic data) async {
    final token = StorageService.getToken();

    try {
      final response = await http
          .put(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));

      return await returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet");
    } on TimeoutException {
      throw RequestTimeoutException("Request Time Out");
    }
  }

  Future<dynamic> patchApi(String url, dynamic data) async {
    final token = StorageService.getToken();

    try {
      final response = await http
          .patch(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));

      return await returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet");
    } on TimeoutException {
      throw RequestTimeoutException("Request Time Out");
    }
  }

  Future<dynamic> deleteApi(String url) async {
    final token = StorageService.getToken();

    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));

      return await returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet");
    } on TimeoutException {
      throw RequestTimeoutException("Request Time Out");
    }
  }

  Future<dynamic> returnResponse(http.Response response) async {
    final body = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
      case 400:
      case 403:
      case 404:
      case 409:
      case 422:
      case 429:
      case 500:
        return body;

      case 401:
        final errorMessage =
            body["error"]?.toString().toLowerCase() ?? "";

        if (errorMessage.contains("access token has expired")) {
          await _handleSessionExpired();
        }
        return body;

      default:
        throw FetchDataException(
          "Error occurred while communicating with server with StatusCode : ${response.statusCode}",
        );
    }
  }

  Future<void> _handleSessionExpired() async {
    if (_isSessionExpiredHandled) return;

    _isSessionExpiredHandled = true;

    await StorageService.removeToken();

    Future.delayed(const Duration(milliseconds: 200), () {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    });
  }

  static void resetSessionFlag() {
    _isSessionExpiredHandled = false;
  }
}
