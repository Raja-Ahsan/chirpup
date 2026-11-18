import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';

class KingdomWorkshopRepository {
  final ApiService _apiService = ApiService();

  Future<dynamic> getGames({required int gameCategoryId, int? yearId}) async {
    String query = 'game_category_id=$gameCategoryId';
    if (yearId != null) {
      query += '&year_id=$yearId';
    }
    return await _apiService.getApi(
      '${ApiConstants.baseUrl}${ApiConstants.getGames}?$query',
    );
  }
}