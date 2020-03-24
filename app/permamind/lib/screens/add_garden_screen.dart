import 'package:arch/arch.dart';
import 'package:authentication/authentication.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:permamind/blocs/blocs.dart';
import 'package:permamind/models/models.dart';
import 'package:permamind/widgets/add_garden_stepper.dart';

class AddGardenScreen extends StatefulWidget {
  final User _user;
  final DataRepository _dataRepository;

  AddGardenScreen(
      {Key key, @required User user, @required DataRepository dataRepository})
      : assert(user != null),
        assert(dataRepository != null),
        _user = user,
        _dataRepository = dataRepository,
        super(key: key);

  @override
  _AddGardenScreenState createState() => _AddGardenScreenState();
}

class _AddGardenScreenState extends State<AddGardenScreen> {
  TextEditingController _gardenName = TextEditingController();

//  final TextEditingController _activityNameController = TextEditingController();

  int _currentStep = 0;
  bool _publicVisibility = false;

  bool _gardenNameValidate = false;

  List<GardenMember> _gardenMembers = List<GardenMember>();

  List<MemberProfile> queryResProfile = List<MemberProfile>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: new AppBar(title: new Text('${AppLocalizations.of(context).addParcelTitle}')),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 82 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
                child: Theme(
                  data: ThemeData(canvasColor: Colors.white),
                  child: AddGardenStepper(
                    steps: [
                      AddGardenStep(
                        title: Text(""),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              'assets/utils_image/sowing.png',
                              fit: BoxFit.scaleDown,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5 * SizeConfig.heightMultiplier),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("Créer un jardin",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: const Color(0xFF01534F),
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                              )),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 2 * SizeConfig.heightMultiplier),
                                    child: TextField(
                                      controller: _gardenName,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.green)),
                                          hintText:
                                              'Donner un nom à votre jardin'),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        isActive: _currentStep >= 0,
                      ),
                      AddGardenStep(
                        title: Text(""),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              'assets/utils_image/growing_plant.png',
                              fit: BoxFit.scaleDown,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5 * SizeConfig.heightMultiplier),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("Rendre le jardin public",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: const Color(0xFF01534F),
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 2 * SizeConfig.heightMultiplier),
                                      child: Container(
                                        height: 50,
                                        color: Colors.grey,
                                      ),
//                                    child: TextField(
//                                      controller: _gardenName,
//                                      decoration: InputDecoration(
//                                          border: OutlineInputBorder(
//                                              borderRadius: BorderRadius.all(
//                                                  Radius.circular(5.0)),
//                                              borderSide: BorderSide(
//                                                  color: Colors.green)),
//                                          hintText:
//                                          'Donner un nom à votre jardin'),
//                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        isActive: _currentStep >= 1,
                      ),
                      AddGardenStep(
                        title: Text(""),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              'assets/utils_image/rake_plant.png',
                              fit: BoxFit.scaleDown,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5 * SizeConfig.heightMultiplier),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("Ajouter des jardiniers",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: const Color(0xFF01534F),
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 2 * SizeConfig.heightMultiplier),
                                    child: Container(
                                      height: 50,
                                      color: Colors.grey,
                                    ),
//                                    child: TextField(
//                                      controller: _gardenName,
//                                      decoration: InputDecoration(
//                                          border: OutlineInputBorder(
//                                              borderRadius: BorderRadius.all(
//                                                  Radius.circular(5.0)),
//                                              borderSide: BorderSide(
//                                                  color: Colors.green)),
//                                          hintText:
//                                          'Donner un nom à votre jardin'),
//                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        isActive: _currentStep >= 2,
                      ),
                    ],
                    controlsBuilder: _createEventControlBuilder,
                    onStepContinue: _currentStep < 3
                        ? () => setState(() => _currentStep += 1)
                        : null,
                    onStepCancel: _currentStep > -1
                        ? () => setState(() => _currentStep -= 1)
                        : null,
                    // Using a variable here for handling the currentStep
                    currentAddGardenStep: this._currentStep,
                    // List the steps you would like to have
                    type: AddGardenStepperType.horizontal,
                    // StepperType.vertical   :  Vertical Style
                    // Know the step that is tapped
                    onAddGardenStepTapped: (step) {
                      // On hitting step itself, change the state and jump to that step
                      setState(() {
                        // update the variable handling the current step value
                        // jump to the tapped step
                        _currentStep = step;
                      });
                      // Log function call
                      print("onStepTapped : " + step.toString());
                    },
//                    onStepCancel: () {
//                      // On hitting cancel button, change the state
//                      setState(() {
//                        // update the variable handling the current step value
//                        // going back one step i.e subtracting 1, until its 0
//                        if (_currentStep > 0) {
//                          _currentStep = _currentStep - 1;
//                        } else {
//                          _currentStep = 0;
//                        }
//                      });
//                      // Log function call
//                      print("onStepCancel : " + _currentStep.toString());
//                    },
                    // On hitting continue button, change the state
//                    onStepContinue: () {
//                      setState(() {
//                        // update the variable handling the current step value
//                        // going back one step i.e adding 1, until its the length of the step
//                        if (_currentStep < 3 - 1) {
//                          _currentStep = _currentStep + 1;
//                        } else {
//                          _currentStep = 0;
//                        }
//                      });
//                      // Log function call
//                      print("onStepContinue : " + _currentStep.toString());
//                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 7 * SizeConfig.widthMultiplier,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );

//    return Scaffold(
//      appBar: new AppBar(title: new Text('${AppLocalizations.of(context).addGardenTitle}')),
//      body: new Stepper(
//        type: StepperType.horizontal,
//        currentStep: _currentStep,
//        onStepTapped: (int step) => setState(() => _currentStep = step),
//        controlsBuilder: _createEventControlBuilder,
//        onStepContinue:
//            _currentStep < 2 ? () => setState(() => _currentStep += 1) : null,
//        onStepCancel:
//            _currentStep > -1 ? () => setState(() => _currentStep -= 1) : null,
//        steps: <Step>[
//          new Step(
//            title: new Text(''),
//            content: Padding(
//                padding: EdgeInsets.only(top: 10, bottom: 30),
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Padding(
//                            padding: EdgeInsets.only(left: 10),
//                            child: Text(
//                              '${AppLocalizations.of(context).addGardenTitle}',
////                    textAlign: TextAlign.left,
////                        overflow: TextOverflow.ellipsis,
//                              style: TextStyle(fontSize: 19),
//                            )),
//                        Container()
//                      ],
//                    ),
//                    Padding(
//                      padding: EdgeInsets.all(10),
//                      child: TextField(
//                        controller: _gardenName,
//                        decoration: InputDecoration(
////                        border: InputBorder.none,
//                          hintText: '${AppLocalizations.of(context).addGardenNameHint}',
//                          errorText: _gardenNameValidate
//                              ? '${AppLocalizations.of(context).addGardenNameError}'
//                              : null,
//                        ),
//                        onChanged: (value) {
//                          _gardenName.text.isEmpty
//                              ? _gardenNameValidate = true
//                              : _gardenNameValidate = false;
//                          setState(() {});
//                        },
//                      ),
//                    )
//                  ],
//                )),
//            isActive: _currentStep >= 0,
//            state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
//          ),
//          new Step(
//            title: new Text(''),
//            content: Padding(
//              padding: EdgeInsets.only(top: 10, bottom: 30),
//              child: Column(
//                children: <Widget>[
//                  Text(
//                    '${AppLocalizations.of(context).addGardenVisibilityTitle}',
//                    textAlign: TextAlign.left,
////                        overflow: TextOverflow.ellipsis,
//                    style: TextStyle(fontSize: 19),
//                  ),
//                  Row(
//                    children: <Widget>[
//                      Radio(
//                        value: true,
//                        groupValue: _publicVisibility,
//                        onChanged: (bool value) {
//                          setState(() {
//                            _publicVisibility = value;
//                          });
//                        },
//                      ),
//                      Text(
//                        '${AppLocalizations.of(context).yesChoice}',
//                        style: new TextStyle(
//                          fontSize: 16.0,
//                        ),
//                      )
//                    ],
//                  ),
//                  Row(
//                    children: <Widget>[
//                      Radio(
//                        value: false,
//                        groupValue: _publicVisibility,
//                        onChanged: (bool value) {
//                          setState(() {
//                            _publicVisibility = value;
//                          });
//                        },
//                      ),
//                      Text(
//                        '${AppLocalizations.of(context).noChoice}',
//                        style: new TextStyle(
//                          fontSize: 16.0,
//                        ),
//                      )
//                    ],
//                  )
//                ],
//              ),
//            ),
//            isActive: _currentStep >= 0,
//            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
//          ),
//          new Step(
//            title: new Text(''),
//            content: Padding(
//              padding: EdgeInsets.only(top: 10, bottom: 30),
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.only(left: 10),
//                        child: Text(
//                          '${AppLocalizations.of(context).addFewGardenersTitle}',
//                          textAlign: TextAlign.left,
////                        overflow: TextOverflow.ellipsis,
//                          style: TextStyle(fontSize: 19),
//                        ),
//                      ),
//                      Container()
//                    ],
//                  ),
//                  Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.only(left: 10),
//                        child: Text(
//                          '${AppLocalizations.of(context).optionalTitle}',
//                          textAlign: TextAlign.left,
////                        overflow: TextOverflow.ellipsis,
//                          style: TextStyle(
//                              fontSize: 15, fontWeight: FontWeight.w300),
//                        ),
//                      ),
//                      Container()
//                    ],
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(10),
//                    child: ChipsInput(
//                      keyboardAppearance: Brightness.dark,
//                      textCapitalization: TextCapitalization.words,
//                      enabled: true,
//                      maxChips: 15,
//                      textStyle: TextStyle(
//                          height: 1.5, fontFamily: "Roboto", fontSize: 16),
//                      decoration: InputDecoration(
//                        prefixIcon: Icon(Icons.search),
//                        // hintText: formControl.hint,
//                        // enabled: false,
//                        // errorText: field.errorText,
//                      ),
//                      findSuggestions: (String query) async {
//                        queryResProfile = [];
//                        if (query.length != 0) {
//                          _gardenMembers = [];
//
//                          var queryRes =
//                              await widget._dataRepository.searchByName(query);
//                          for (int i = 0; i < queryRes.documents.length; ++i) {
//                            var data = queryRes.documents[i].data;
//                            queryResProfile.add(MemberProfile(
//                              data["id"],
//                              data["pseudo"],
////                                  data["email"],
////                                  'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg'
//                            ));
//                          }
//                        }
//                        return queryResProfile;
//                      },
//                      onChanged: (data) {
//                        _gardenMembers.clear();
//                        data.forEach((elem) {
//                          if (elem.pseudo != widget._user.pseudo) {
//                            _gardenMembers.add(
//                                GardenMember(id: elem.id, pseudo: elem.pseudo));
//                          }
//                        });
//                      },
//                      chipBuilder: (context, state, profile) {
//                        return InputChip(
//                          key: ObjectKey(profile),
//                          label: Text(profile.pseudo),
////                            avatar: CircleAvatar(
////                              backgroundImage: NetworkImage(profile.imageUrl),
////                            ),
//                          onDeleted: () => state.deleteChip(profile),
//                          materialTapTargetSize:
//                              MaterialTapTargetSize.shrinkWrap,
//                        );
//                      },
//                      suggestionBuilder: (context, state, profile) {
//                        return ListTile(
//                          key: ObjectKey(profile),
////                            leading: CircleAvatar(
////                              backgroundImage: NetworkImage(profile.imageUrl),
////                            ),
//                          title: Text(profile.pseudo),
////                            subtitle: Text(profile.email),
//                          onTap: () => state.selectSuggestion(profile),
//                        );
//                      },
//                    ),
//                  )
//                ],
//              ),
//            ),
//            isActive: _currentStep >= 0,
//            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
//          ),
//        ],
//      ),
//    );
  }

  Widget _createEventControlBuilder(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    if (_currentStep == 2) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
                textColor: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green)),
                color: Colors.white,
                onPressed: () {
                  if (_gardenName.text.isNotEmpty) {
                    onStepCancel();
                  } else {
                    setState(() {
                      _gardenName.text.isEmpty
                          ? _gardenNameValidate = true
                          : _gardenNameValidate = false;
                    });
                  }
                },
                child: Text('${AppLocalizations.of(context).backButton}')),
            RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  // TODO Création du jardin !
//                  _gardenMembers.add(GardenMember(
//                      id: widget._user.id, pseudo: widget._user.pseudo));
//
//                  final Garden garden = Garden(
//                      "${_gardenName.text}",
//                      _publicVisibility,
//                      widget._user.id,
//                      _gardenMembers,
//                      DateTime.now(),
//                      0);
//
//                  BlocProvider.of<GardensBloc>(context).add(AddGarden(garden));
//
//                  Navigator.pop(context);
////                  Navigator.pushNamedAndRemoveUntil(
////                      context, (_) => false);
                },
                child: Text('${AppLocalizations.of(context).finalizeButton}')),
          ]);
    } else if (_currentStep == 0) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  if (_gardenName.text.isNotEmpty) {
                    onStepContinue();
                  } else {
                    setState(() {
                      _gardenName.text.isEmpty
                          ? _gardenNameValidate = true
                          : _gardenNameValidate = false;
                    });
                  }
                },
                child: Text('${AppLocalizations.of(context).continueButton}')),
          ]);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
                textColor: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green)),
                color: Colors.white,
                onPressed: () {
                  if (_gardenName.text.isNotEmpty) {
                    onStepCancel();
                  } else {
                    setState(() {
                      _gardenName.text.isEmpty
                          ? _gardenNameValidate = true
                          : _gardenNameValidate = false;
                    });
                  }
                },
                child: Text('${AppLocalizations.of(context).backButton}')),
            RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  if (_gardenName.text.isNotEmpty) {
                    onStepContinue();
                  } else {
                    setState(() {
                      _gardenName.text.isEmpty
                          ? _gardenNameValidate = true
                          : _gardenNameValidate = false;
                    });
                  }
                },
                child: Text('${AppLocalizations.of(context).continueButton}')),
          ]);
    }
  }
}
