import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';

class ChildDashboardRepository {
  final ApiService _apiService = ApiService();

  Future<dynamic> getDashboard(String childId) async {
    return await _apiService.getApi(
      "${ApiConstants.baseUrl}/children/$childId/dashboard",
    );
  }

  Future<dynamic> getTodayMood(String childId) async {
    return await _apiService.getApi(
      "${ApiConstants.baseUrl}/children/$childId/mood/today",
    );
  }

  Future<dynamic> updateMood({
    required String childId,
    required String mood,
    required String date,
  }) async {
    return await _apiService.postApi(
      "${ApiConstants.baseUrl}/children/$childId/mood",
      {'mood': mood, 'date': date},
    );
  }
}
