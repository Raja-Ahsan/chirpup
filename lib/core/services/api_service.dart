import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chirp_up_app/core/errors/app_exceptions.dart';
import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static bool _isSessionExpiredHandled = false;

  Future<dynamic> getApi(String url) async {
    final token = StorageService.getToken();
    dynamic jsonResponse;
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));
      jsonResponse = await returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet');
    } on TimeoutException {
      throw RequestTimeoutException('Request Time Out');
    }
    return jsonResponse;
  }

  Future<dynamic> postApi(String url, data) async {
    final token = StorageService.getToken();
    dynamic jsonResponse;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: json.encode(data),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      jsonResponse = await returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet');
    } on TimeoutException {
      throw RequestTimeoutException('Request Time Out');
    }
    return jsonResponse;
  }

  Future<dynamic> putApi(String url, data) async {
    final token = StorageService.getToken();
    dynamic jsonResponse;
    try {
      final response = await http
          .put(
            Uri.parse(url),
            body: json.encode(data),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      jsonResponse = await returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet');
    } on TimeoutException {
      throw RequestTimeoutException('Request Time Out');
    }
    return jsonResponse;
  }

  Future<dynamic> patchApi(String url, data) async {
    final token = StorageService.getToken();
    dynamic jsonResponse;
    try {
      final response = await http
          .patch(
            Uri.parse(url),
            body: json.encode(data),
            headers: {
              "Accept": "application/json",
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      jsonResponse = await returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet');
    } on TimeoutException {
      throw RequestTimeoutException('Request Time Out');
    }
    return jsonResponse;
  }

  Future<dynamic> deleteApi(String url) async {
    final token = StorageService.getToken();
    dynamic jsonResponse;
    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));
      jsonResponse = await returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet');
    } on TimeoutException {
      throw RequestTimeoutException('Request Time Out');
    }
    return jsonResponse;
  }

  Future<dynamic> returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 400:
      case 403:
      case 404:
      case 422:
      case 429:
      case 500:
        return jsonDecode(response.body);

      case 401:
        if (!_isSessionExpiredHandled) {
          _isSessionExpiredHandled = true;

          await StorageService.removeToken();
          Future.delayed(const Duration(milliseconds: 200), () {
            // Get.offAll(() => LoginView());
          });
        }

        throw UnAuthorisedException('Session expired');

      default:
        throw FetchDataException(
          'Error occurred while communicating with server with StatusCode : ${response.statusCode}',
        );
    }
  }

  static void resetSessionFlag() {
    _isSessionExpiredHandled = false;
  }
}
