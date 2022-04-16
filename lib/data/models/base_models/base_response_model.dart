class BaseSingleResponse<T> {
  int? status;
  String? message;
  String? path;
  T? model;

  BaseSingleResponse({
    this.status,
    this.message,
    this.path,
    this.model,
  });

  factory BaseSingleResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) build) {
    return BaseSingleResponse<T>(status: json['status'], message: json['message'], path: json['path'], model: build(json['model']));
  }
}

class BaseListResponse<T> {
  int? status;
  String? message;
  String? path;
  List<T>? model;

  BaseListResponse({
    this.status,
    this.message,
    this.path,
    this.model,
  });

  factory BaseListResponse.fromJson(Map<String, dynamic> json, Function(List<dynamic>) build) {
    return BaseListResponse<T>(status: json['status'], message: json['message'],  path: json['path'], model: build(json['model']));
  }
}
