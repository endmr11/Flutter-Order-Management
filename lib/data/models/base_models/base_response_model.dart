class BaseResponseModel<T> {
  int? status;
  String? message;
  String? path;
  List<T>? model;

  BaseResponseModel(Map<String, dynamic> json, dynamic Function(List<Map<String, dynamic>?>) listConstructor) {
    status = json['status'];
    message = json['message'];
    path = json['path'];
    model = listConstructor(castToList(json['model'])) as List<T>;
  }

  static List<Map<String, dynamic>?> castToList(dynamic object) {
    final rawArray = List<dynamic>.from(object);
    final mapList = <Map<String, dynamic>?>[];
    for (final model in rawArray) {
      mapList.add(model.cast<String, dynamic>());
    }
    return mapList;
  }
}
