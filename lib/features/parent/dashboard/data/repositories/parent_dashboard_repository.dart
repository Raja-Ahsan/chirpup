import 'package:chirp_up_app/core/constants/api_constants.dart';
import 'package:chirp_up_app/core/services/api_service.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/child_week_status_model.dart';

class ParentDashboardRepository {
  final ApiService _apiService = ApiService();

  Future<AllChildrenModel> fetchChildren() async {
    final response = await _apiService.getApi(
      ApiConstants.baseUrl + ApiConstants.getParentChildrens,
    );
    return AllChildrenModel.fromJson(response);
  }

  Future<ChildWeekStatusModel> fetchChildWeeklyStats(String childId) async {
    final response = await _apiService.getApi(
      '${ApiConstants.baseUrl}/children/$childId/weekly-stats',
    );
    return ChildWeekStatusModel.fromJson(response);
  }
}
