// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Log _$LogFromJson(Map<String, dynamic> json) => Log(
      id: json['id'] as int,
      tag: json['tag'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$LogToJson(Log instance) => <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
