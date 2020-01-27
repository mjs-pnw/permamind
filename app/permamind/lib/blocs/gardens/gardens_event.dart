import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:data_repository/data_repository.dart';

@immutable
abstract class GardensEvent extends Equatable {
  GardensEvent([List props = const []]) : super(props);
}

class GardensInit extends GardensEvent {
  @override
  String toString() => 'GardensInit';
}

class LoadGardens extends GardensEvent {

  final String userId;

  LoadGardens(this.userId) : super([userId]);

  @override
  String toString() => 'LoadGardens { userId: $userId}';
}

class AddGarden extends GardensEvent {
  final Garden garden;

  final List<ModelingSchedule> schedule;

  AddGarden(this.garden, this.schedule) : super([garden, schedule]);

  @override
  String toString() => 'AddGarden { garden: $garden }';
}


class CopyGarden extends GardensEvent {
  final Garden garden;

  CopyGarden(this.garden) : super([garden]);

  @override
  String toString() => 'CopyGarden { garden: $garden }';
}

class UpdateGarden extends GardensEvent {
  final Garden updatedGarden;

  UpdateGarden(this.updatedGarden) : super([updatedGarden]);

  @override
  String toString() => 'UpdateGarden { updatedGarden: $updatedGarden }';
}

class DeleteGarden extends GardensEvent {
  final Garden garden;

  DeleteGarden(this.garden) : super([garden]);

  @override
  String toString() => 'DeleteGarden { garden: $garden }';
}

class ClearCompleted extends GardensEvent {
  @override
  String toString() => 'ClearCompleted';
}

class ToggleAll extends GardensEvent {
  @override
  String toString() => 'ToggleAll';
}

class GardensUpdated extends GardensEvent {
  final List<Garden> gardens;

  GardensUpdated(this.gardens);

  @override
  String toString() => 'GardensUpdated';
}

//
//class AddGardenActivities extends GardensEvent {
//
//  final List<ModelingSchedule> schedule;
//  final String gardenId;
//
//  AddGardenActivities(this.gardenId, this.schedule);
//
//  @override
//  String toString() => 'GardensUpdated';
//}
