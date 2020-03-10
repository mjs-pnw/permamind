import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:meta/meta.dart';
import 'package:permamind/blocs/blocs.dart';


class DesignBloc extends Bloc<DesignEvent, DesignState> {

  final String parcelId;
  final ActivitiesBloc activitiesBloc;
  StreamSubscription _designSubscription;
  final DataRepository dataRepository;


  DesignBloc({@required this.dataRepository,
            @required this.activitiesBloc,
            @required this.parcelId}) {
//    _designSubscription = activitiesBloc.listen((state) {
//      if (state is ActivitiesLoaded) {
//        add(UpdateDesign(state));
//      }
//    });
  }

  @override
  DesignState get initialState => DesignLoading();


  @override
  Stream<DesignState> mapEventToState(DesignEvent event) async* {
    if (event is LoadDesign) {
      yield* _mapLoadDesignToState();
    } else if (event is DesignUpdated) {
      yield* _mapDesignUpdatedToState(event);
    } else if (event is UpdateDesign) {
      yield* _mapUpdateDesignToState(event);
    }
  }

  Stream<DesignState> _mapUpdateDesignToState(
      UpdateDesign event,
      ) async* {
  }

  Stream<DesignState> _mapLoadDesignToState() async* {
    _designSubscription?.cancel();
    _designSubscription = dataRepository.loadDesignParcel(parcelId).listen(
          (gardenDesign) {
            if (gardenDesign.isNotEmpty) {
              add(DesignUpdated(gardenDesign.first));
            }
      },
    );
  }

  Stream<DesignState> _mapDesignUpdatedToState(DesignUpdated event) async* {
    yield DesignLoaded(event.gardenDesign);
  }



  @override
  Future<void> close() {
    _designSubscription.cancel();
    return super.close();
  }
}