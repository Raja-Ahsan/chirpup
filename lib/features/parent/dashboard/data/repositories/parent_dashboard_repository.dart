import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/child_detail_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/game_categories_model.dart';

class ParentDashboardRepository {
  final ApiService _apiService = ApiService();

  Future<AllChildrenModel> fetchChildren() async {
    final response = await _apiService.getApi(
      ApiConstants.baseUrl + ApiConstants.getParentChildrens,
    );
    return AllChildrenModel.fromJson(response);
  }

  Future<ChildDetailModel> fetchChildDetail(String slug) async {
    final response = await _apiService.getApi(
      '${ApiConstants.baseUrl}/children/$slug',
    );
    return ChildDetailModel.fromJson(response);
  }

  Future<GameCategoriesModel> fetchGameCategories() async {
    final response = await _apiService.getApi(
      ApiConstants.baseUrl + ApiConstants.getGameCategories,
    );
    return GameCategoriesModel.fromJson(response);
  }
}
