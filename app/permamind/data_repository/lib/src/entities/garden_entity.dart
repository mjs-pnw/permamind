import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

class GardenEntity extends Equatable {
  final String id;
  final String name;
  final bool publicVisibility;
  final String modelingId;
  final String modelingName;
  final List<String> members;
  List<PlanningDay> schedule = new List<PlanningDay>();
  final DateTime creationDate;

  GardenEntity(this.id,
      this.name,
      this.publicVisibility,
      this.members,
      this.modelingId,
      this.modelingName,
      this.schedule,
      this.creationDate);

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'publicVisibility': publicVisibility,
      'members': members,
      'modelingName': modelingName,
      'schedule': schedule.map((item) {
        return item.toJson();
      }).toList(),
      'creationDate': creationDate
    };
  }

  @override
  String toString() {
    return 'GardenEntity { id: $id, name: $name, publicVisibility: $publicVisibility, members: $members }';
  }

  static GardenEntity fromJson(Map<String, Object> json) {
    return GardenEntity(
      json['id'] as String,
      json['name'] as String,
      json['publicVisibility'] as bool,
      json['members'],
      json['modelingId'] as String,
      json['modelingName'] as String,
      json['schedule'] as List<PlanningDay>,
      json['creationDate']
    );
  }

  static GardenEntity fromSnapshot(DocumentSnapshot snap) {

    List<String> gardenList = new List<String>.from(snap.data['members']);

    return GardenEntity(
      snap.documentID,
      snap.data['name'],
      snap.data['publicVisibility'],
      gardenList,
      snap.data['modelingId'],
      snap.data['modelingName'],
      snap.data['schedule'].map<PlanningDay>((item) {
        return PlanningDay.fromMap(item);
      }).toList(),
        DateTime.fromMillisecondsSinceEpoch(
            snap.data["creationDate"].millisecondsSinceEpoch)
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'publicVisibility': publicVisibility,
      'members': members,
      'modelingId': modelingId,
      'modelingName': modelingName,
      'schedule': schedule.map((item) {
        return item.toJson();
      }).toList(),
      'creationDate': creationDate
    };
  }
}