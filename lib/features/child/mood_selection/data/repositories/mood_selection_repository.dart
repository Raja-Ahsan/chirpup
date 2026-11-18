import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';

class MoodSelectionRepository {
  final ApiService _apiService;

  MoodSelectionRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<dynamic> getMoods() async {
    return await _apiService.getApi(
      ApiConstants.baseUrl + ApiConstants.getMoods,
    );
  }
  Future<dynamic> submitMood({
    required String childSlug,
    required String childId,
    required int moodId,
    required String date,
  }) async {
    return await _apiService.postApi(
      '${ApiConstants.baseUrl}/children/$childSlug/mood',
      {'children_id': childId, 'mood_id': moodId, 'date': date},
    );
  }
}