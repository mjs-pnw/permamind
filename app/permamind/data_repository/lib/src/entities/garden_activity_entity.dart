import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String title;
  final String gardenId;
  final bool complete;
  final DateTime expectedDate;

  ActivityEntity(this.id,
      this.title,
      this.gardenId,
      this.complete,
      this.expectedDate);

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'expectedDate': expectedDate
    };
  }

  @override
  String toString() {
    return 'ActivityEntity { id: $id, title: $title }';
  }

  static ActivityEntity fromJson(Map<String, Object> json) {
    return ActivityEntity(
        json['id'] as String,
        json['title'] as String,
        json['gardenId'] as String,
        json['complete'] as bool,
        json['expectedDate']
    );
  }

  static ActivityEntity fromSnapshot(DocumentSnapshot snap) {

    return ActivityEntity(
        snap.documentID,
        snap.data['title'],
        snap.data['complete'],
        snap.data['gardenId'],
        DateTime.fromMillisecondsSinceEpoch(
            snap.data["expectedDate"].millisecondsSinceEpoch)
    );
  }

  Map<String, Object> toDocument() {
    return {
      'title': title,
      'complete': complete,
      'gardenId': gardenId,
      'expectedDate': expectedDate
    };
  }
}