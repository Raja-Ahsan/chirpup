import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';

class MoodSelectionRepository {
  final ApiService _apiService;

  MoodSelectionRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<dynamic> submitMood({
    required String childId,
    required String mood,
    required String date,
  }) async {
    final response = await _apiService.postApi(
      "${ApiConstants.baseUrl}/children/$childId/mood",
      {'mood': mood, 'date': date},
    );

    return response;
  }
}