import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';

class ChildProfileSelectionRepository {
  final ApiService _apiService = ApiService();

  Future<AllChildrenModel> fetchChildren() async {
    final response = await _apiService.getApi(
      ApiConstants.baseUrl + ApiConstants.getParentChildrens,
    );
    return AllChildrenModel.fromJson(response);
  }

  Future<dynamic> checkTodayMood(String childId) async {
    return await _apiService.getApi(
      '${ApiConstants.baseUrl}/children/$childId/mood/today',
    );
  }

  Future<dynamic> checkPinStatus() async {
    return await _apiService.getApi(
      ApiConstants.baseUrl + ApiConstants.pinStatus,
    );
  }

  Future<dynamic> verifyPin(String pin) async {
    return await _apiService.postApi(
      ApiConstants.baseUrl + ApiConstants.verifyPin,
      {"pin": pin},
    );
  }
}
