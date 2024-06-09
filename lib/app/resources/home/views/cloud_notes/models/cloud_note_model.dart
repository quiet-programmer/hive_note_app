import 'package:hive/hive.dart';

part 'cloud_note_model.g.dart';

@HiveType(typeId: 1)
class CloudNoteModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? uuid;

  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String? notes;

  @HiveField(4)
  final dynamic dateTime;

  @HiveField(5)
  final int? isTrashed;

  CloudNoteModel({
    this.id,
    this.uuid,
    this.title,
    this.notes,
    this.dateTime,
    this.isTrashed,
  });

  factory CloudNoteModel.fromJson(Map<String, dynamic> response) {
    return CloudNoteModel(
      id: response['data']['id'],
      uuid: response['data']['uuid'],
      title: response['data']['note_title'],
      notes: response['data']['note_content'],
      isTrashed: response['data']['is_trashed'],
      dateTime: response['data']['created_at'],
    );
  }

  static List<CloudNoteModel> parseResponse(Map<String, dynamic> responseData) {
    if (responseData['success'] == true && responseData['data'] != null) {
      List<dynamic> followingData = responseData['data'];
      return followingData.map((json) => CloudNoteModel.fromJson(json)).toList();
    }
    return [];
  }

}