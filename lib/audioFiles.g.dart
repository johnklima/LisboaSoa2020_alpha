// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audioFiles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioFiles _$AudioFilesFromJson(Map<String, dynamic> json) {
  return AudioFiles(
    json['guid'] as String,
    json['position'] as String,
    json['duration'] as String,
    json['location'] as String,
  );
}

Map<String, dynamic> _$AudioFilesToJson(AudioFiles instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'position': instance.position,
      'duration': instance.duration,
      'location': instance.location,
    };
