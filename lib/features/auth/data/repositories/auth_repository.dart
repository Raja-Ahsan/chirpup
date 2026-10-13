import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<dynamic> getCharacters() async {
    return await _apiService.getApi(
      ApiConstants.baseUrl + ApiConstants.getCharacters,
    );
  }

  Future<dynamic> getYears() async {
    return await _apiService.getApi(ApiConstants.baseUrl + ApiConstants.getYears);
  }

  Future<dynamic> registerUser(Map data) async {
    final response = await _apiService.postApi(
      ApiConstants.baseUrl + ApiConstants.createAccount,
      data,
    );
    return response;
  }

  Future<dynamic> verifyOtp(Map data) async {
    final response = await _apiService.postApi(
      ApiConstants.baseUrl + ApiConstants.verifyEmail,
      data,
    );
    return response;
  }

  Future<dynamic> resendOtp(Map data) async {
    final response = await _apiService.postApi(
      ApiConstants.baseUrl + ApiConstants.resendOTP,
      data,
    );
    return response;
  }

  Future<dynamic> createChildProfile(Map data) async {
    final response = await _apiService.postApi(
      ApiConstants.baseUrl + ApiConstants.createChildProfile,
      data,
    );
    return response;
  }

  Future<dynamic> setupPin(Map data) async {
    final response = await _apiService.postApi(
      ApiConstants.baseUrl + ApiConstants.parentPin,
      data,
    );
    return response;
  }

  Future<dynamic> login(Map data) async {
    final response = await _apiService.postApi(
      ApiConstants.baseUrl + ApiConstants.login,
      data,
    );
    return response;
  }
}
