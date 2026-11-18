import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';

class ChildDetailModel {
  final Child? child;
  final bool success;
  final String message;
  final int code;

  ChildDetailModel({
    required this.child,
    required this.success,
    required this.message,
    required this.code,
  });

  factory ChildDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final childJson = data is Map ? data['child'] : null;

    return ChildDetailModel(
      child: childJson is Map<String, dynamic>
          ? Child.fromJson(childJson)
          : null,
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      code: json['code'] ?? 0,
    );
  }
}