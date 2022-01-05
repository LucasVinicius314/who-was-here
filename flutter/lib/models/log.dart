import 'package:json_annotation/json_annotation.dart';

part 'log.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Log {
  final int id;
  final String tag;
  final String createdAt;
  final String updatedAt;

  Log({
    required this.id,
    required this.tag,
    required this.createdAt,
    required this.updatedAt,
  });

  DateTime get getCreatedAt =>
      (DateTime.tryParse(createdAt) ?? DateTime.now()).toLocal();
  DateTime get getUpdatedAt =>
      (DateTime.tryParse(updatedAt) ?? DateTime.now()).toLocal();

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);

  Map<String, dynamic> toJson() => _$LogToJson(this);
}
