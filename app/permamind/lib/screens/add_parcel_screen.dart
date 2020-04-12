import 'package:arch/arch.dart';
import 'package:authentication/authentication.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:permamind/blocs/blocs.dart';
import 'package:permamind/models/member_profile.dart';
import 'package:permamind/screens/screens.dart';
import 'package:permamind/widgets/widgets.dart';

//typedef AddParcelCallback = Function(String task, String note);

class AddParcelScreen extends StatefulWidget {
  final Garden garden;
  final User user;

  final DataRepository dataRepository;

  AddParcelScreen({
    Key key,
    @required this.dataRepository,
    @required this.garden,
    @required this.user,
  })  : assert(garden != null),
        super(key: key);

  @override
  _AddParcelScreenState createState() => _AddParcelScreenState();
}

class _AddParcelScreenState extends State<AddParcelScreen> {
  TextEditingController _parcelName = TextEditingController();

  int _currentStep = 0;
  bool _parcelOnBac = false;

  bool _parcelNameValidate = false;

  List<GardenMember> _parcelMembers = List<GardenMember>();

  List<MemberProfile> queryResProfile = List<MemberProfile>();

  String gardenLengthValue;

  String gardenWidthValue;

  @override
  void initState() {
    for (final member in widget.garden.members) {
      if (member.id != widget.user.id) {
        _parcelMembers.add(member);
        queryResProfile.add(MemberProfile(member.id, member.pseudo));
      }
    }
    super.initState();
  }

  final List<String> lengths = <String>["80", "100", "200", "300"];

  final List<String> widths = <String>["60", "80", "100"];

  Map<Vegetable, bool> veggiesSelected;
  Map<String, Vegetable> veggiesComposition = Map<String, Vegetable>();

  @override
  Widget build(BuildContext context) {


    final parcelBloc = BlocProvider.of<ParcelsBloc>(context);

    return BlocBuilder<ModelingsBloc, ModelingsState>(
        builder: (context, state) {
      if (state is VeggiesLoaded) {

        if (veggiesSelected == null) {
          veggiesSelected = Map.fromIterable(state.veggies, key: (v) => v, value: (v) => false);
        }

        veggiesComposition = Map.fromIterable(state.veggies, key: (v) => v.id, value: (v) => v);

        return Scaffold(
          body: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                            child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 7 * SizeConfig.widthMultiplier,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        )),
                        Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: Container(
//                              color: Colors.green,
                                child: _currentStep == 4
                                    ? Text(
                                        "Quels légumes voulez-vous cultiver ?",
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: const Color(0xFF01534F),
                                          fontSize:
                                              2.5 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold,
                                        ))
                                    : Container(),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 6,
                      child: Container(
                        child: Theme(
                          data: ThemeData(
                              canvasColor: Colors.white,
                              primaryColor: Colors.green),
                          child: MyStepper(
                            steps: [
                              MyStep(
                                title: Text(""),
                                content: Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                              Text("Créer une parcelle",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xFF01534F),
                                                      fontSize: 2.5 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                      )),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 2 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            child: TextField(
                                              controller: _parcelName,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.green)),
                                                hintText:
                                                    'Donner un nom à votre parcelle',
                                                errorText: _parcelNameValidate
                                                    ? "Le nom d'une parcelle ne peut être vide"
                                                    : null,
                                              ),
                                              onChanged: (value) {
                                                _parcelName.text.isEmpty
                                                    ? _parcelNameValidate = true
                                                    : _parcelNameValidate =
                                                        false;
                                                setState(() {});
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                              ),
                              MyStep(
                                title: Text(""),
                                content: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/utils_image/bac.png',
                                      fit: BoxFit.scaleDown,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 2 * SizeConfig.heightMultiplier),
                                      child: Row(
                                        children: <Widget>[
                                          Text("Dimensions en centimètres",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xFF01534F),
                                                  fontSize: 2.5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                  )),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 2 * SizeConfig.heightMultiplier),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                              flex: 10,
                                              child: PopupMenuButton<String>(
                                                itemBuilder: (context) {
                                                  return lengths
                                                      .map((String item) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(item),
                                                    );
                                                  }).toList();
                                                },
                                                onSelected: (String newValue) {
                                                  setState(() {
                                                    gardenLengthValue =
                                                        newValue;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFF01534F),
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          gardenLengthValue ==
                                                                  null
                                                              ? "Longueur"
                                                              : gardenLengthValue,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xFF01534F),
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .textMultiplier,
//                          fontWeight: FontWeight.bold,
                                                          )),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        size: 7 *
                                                            SizeConfig
                                                                .widthMultiplier,
                                                        color: const Color(
                                                            0xFF01534F),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          Spacer(),
                                          Flexible(
                                              flex: 10,
                                              child: PopupMenuButton<String>(
                                                itemBuilder: (context) {
                                                  return widths
                                                      .map((String item) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(item),
                                                    );
                                                  }).toList();
                                                },
                                                onSelected: (String newValue) {
                                                  setState(() {
                                                    gardenWidthValue = newValue;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFF01534F),
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          gardenWidthValue ==
                                                                  null
                                                              ? "Largeur"
                                                              : gardenWidthValue,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xFF01534F),
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .textMultiplier,
//                          fontWeight: FontWeight.bold,
                                                          )),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        size: 7 *
                                                            SizeConfig
                                                                .widthMultiplier,
                                                        color: const Color(
                                                            0xFF01534F),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    )
//
                                  ],
                                ),
                                isActive: _currentStep >= 1,
                              ),
                              MyStep(
                                title: Text(""),
                                content: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/utils_image/tree.png',
                                      fit: BoxFit.scaleDown,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 2 * SizeConfig.heightMultiplier),
                                      child: Text(
                                          "Utilisez-vous un bac de culture ?",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: const Color(0xFF01534F),
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                              )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 2 * SizeConfig.heightMultiplier),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 10,
                                            child: RadioListTile<bool>(
                                              title: const Text('Oui'),
                                              value: true,
                                              groupValue: _parcelOnBac,
                                              activeColor: Colors.green,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  _parcelOnBac = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Spacer(),
                                          Flexible(
                                            flex: 10,
                                            child: RadioListTile<bool>(
                                              title: const Text('Non'),
                                              value: false,
                                              activeColor: Colors.green,
                                              groupValue: _parcelOnBac,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  _parcelOnBac = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                isActive: _currentStep >= 2,
                              ),
                              MyStep(
                                title: Text(""),
                                content: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                      color: const Color(
                                                          0xFF01534F),
                                                      fontSize: 2.5 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                      )),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 2 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            child: ChipsInput(
                                              keyboardAppearance:
                                                  Brightness.dark,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              enabled: true,
                                              maxChips: 15,
                                              textStyle: TextStyle(
                                                  height: 1.5,
                                                  fontFamily: "Roboto",
                                                  fontSize: 16),
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                      borderSide: BorderSide(
                                                          color: Colors.green)),
                                                  hintText:
                                                      'Inviter des jardiniers'),
                                              findSuggestions:
                                                  (String query) async {
                                                queryResProfile = [];
                                                if (query.length != 0) {
                                                  _parcelMembers = [];

                                                  var queryRes = await widget
                                                      .dataRepository
                                                      .searchByName(query);
                                                  for (int i = 0;
                                                      i <
                                                          queryRes
                                                              .documents.length;
                                                      ++i) {
                                                    var data = queryRes
                                                        .documents[i].data;
                                                    queryResProfile
                                                        .add(MemberProfile(
                                                      data["id"],
                                                      data["pseudo"],
//                                  data["email"],
//                                  'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg'
                                                    ));
                                                  }
                                                }
                                                return queryResProfile;
                                              },
                                              onChanged: (data) {
                                                _parcelMembers.clear();
                                                data.forEach((elem) {
                                                  if (elem.pseudo !=
                                                      widget.user.pseudo) {
                                                    _parcelMembers.add(
                                                        GardenMember(
                                                            id: elem.id,
                                                            pseudo:
                                                                elem.pseudo));
                                                  }
                                                });
                                              },
                                              chipBuilder:
                                                  (context, state, profile) {
                                                return InputChip(
                                                  key: ObjectKey(profile),
                                                  label: Text(profile.pseudo),
//                            avatar: CircleAvatar(
//                              backgroundImage: NetworkImage(profile.imageUrl),
//                            ),
                                                  onDeleted: () =>
                                                      state.deleteChip(profile),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                );
                                              },
                                              suggestionBuilder:
                                                  (context, state, profile) {
                                                return ListTile(
                                                  key: ObjectKey(profile),
//                            leading: CircleAvatar(
//                              backgroundImage: NetworkImage(profile.imageUrl),
//                            ),
                                                  title: Text(profile.pseudo),
//                            subtitle: Text(profile.email),
                                                  onTap: () =>
                                                      state.selectSuggestion(
                                                          profile),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                isActive: _currentStep >= 3,
                              ),
                              MyStep(
                                title: Text(""),
                                content:  Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      color: Colors.white70,
                                      height: 500,
                                      child: ListView(
                                        children: state.veggies
                                            .map((vegetable) {
                                          return new CheckboxListTile(
                                            title:
                                            new Text(vegetable.nameFr),
                                            value: veggiesSelected[vegetable],
                                            secondary: Image(
                                              height: 40,
                                              width: 40,
                                              image: AssetImage(
                                                  'assets/veggies/${vegetable.imageName}.png'),
                                            ),
                                            onChanged: (bool value) {
                                              setState(() {
                                                veggiesSelected.update(vegetable, (existingValue) => value, ifAbsent: () => value,);
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                                isActive: _currentStep >= 4,
                              ),
                            ],
                            controlsBuilder: _createEventControlBuilder,
                            onStepContinue: _currentStep < 5
                                ? () {
                                    if (_currentStep != 4) {
                                      setState(() => _currentStep += 1);
                                    }
                                  }
                                : null,
                            onStepCancel: _currentStep > -1
                                ? () => setState(() => _currentStep -= 1)
                                : null,
                            // Using a variable here for handling the currentStep
                            currentMyStep: this._currentStep,
                            // List the steps you would like to have
                            type: MyStepperType.horizontal,
                          ),
                        ),
                      ))
                ],
              )),
        );
      } else if (state is ModelingsLoaded) {

        if (state.modelingsFetched.isEmpty) {
          return Scaffold(
            body: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 7 * SizeConfig.widthMultiplier,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              )),
                          Flexible(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Container(
                                  child: Container(),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 6,
                        child: Container(
                          child: Theme(
                            data: ThemeData(
                                canvasColor: Colors.white,
                                primaryColor: Colors.green),
                            child: MyStepper(
                              steps: [
                                MyStep(
                                  title: Text(""),
                                  content: Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                Text("Créer une parcelle",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xFF01534F),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                        FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: TextField(
                                                controller: _parcelName,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0)),
                                                      borderSide: BorderSide(
                                                          color: Colors.green)),
                                                  hintText:
                                                  'Donner un nom à votre parcelle',
                                                  errorText: _parcelNameValidate
                                                      ? "Le nom d'une parcelle ne peut être vide"
                                                      : null,
                                                ),
                                                onChanged: (value) {
                                                  _parcelName.text.isEmpty
                                                      ? _parcelNameValidate = true
                                                      : _parcelNameValidate =
                                                  false;
                                                  setState(() {});
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  isActive: _currentStep >= 0,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/utils_image/bac.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Text("Dimensions en centimètres",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                    const Color(0xFF01534F),
                                                    fontSize: 2.5 *
                                                        SizeConfig.textMultiplier,
                                                    fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                                flex: 10,
                                                child: PopupMenuButton<String>(
                                                  itemBuilder: (context) {
                                                    return lengths
                                                        .map((String item) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList();
                                                  },
                                                  onSelected: (String newValue) {
                                                    setState(() {
                                                      gardenLengthValue =
                                                          newValue;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xFF01534F),
                                                          width: 0.5),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(
                                                            gardenLengthValue ==
                                                                null
                                                                ? "Longueur"
                                                                : gardenLengthValue,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF01534F),
                                                              fontSize: 2 *
                                                                  SizeConfig
                                                                      .textMultiplier,
//                          fontWeight: FontWeight.bold,
                                                            )),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 7 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          color: const Color(
                                                              0xFF01534F),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                            Spacer(),
                                            Flexible(
                                                flex: 10,
                                                child: PopupMenuButton<String>(
                                                  itemBuilder: (context) {
                                                    return widths
                                                        .map((String item) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList();
                                                  },
                                                  onSelected: (String newValue) {
                                                    setState(() {
                                                      gardenWidthValue = newValue;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xFF01534F),
                                                          width: 0.5),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(
                                                            gardenWidthValue ==
                                                                null
                                                                ? "Largeur"
                                                                : gardenWidthValue,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF01534F),
                                                              fontSize: 2 *
                                                                  SizeConfig
                                                                      .textMultiplier,
//                          fontWeight: FontWeight.bold,
                                                            )),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 7 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          color: const Color(
                                                              0xFF01534F),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      )
//
                                    ],
                                  ),
                                  isActive: _currentStep >= 1,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/utils_image/tree.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Text(
                                            "Utilisez-vous un bac de culture ?",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: const Color(0xFF01534F),
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 10,
                                              child: RadioListTile<bool>(
                                                title: const Text('Oui'),
                                                value: true,
                                                groupValue: _parcelOnBac,
                                                activeColor: Colors.green,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _parcelOnBac = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            Spacer(),
                                            Flexible(
                                              flex: 10,
                                              child: RadioListTile<bool>(
                                                title: const Text('Non'),
                                                value: false,
                                                activeColor: Colors.green,
                                                groupValue: _parcelOnBac,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _parcelOnBac = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  isActive: _currentStep >= 2,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                                        color: const Color(
                                                            0xFF01534F),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                        FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: ChipsInput(
                                                keyboardAppearance:
                                                Brightness.dark,
                                                textCapitalization:
                                                TextCapitalization.words,
                                                enabled: true,
                                                maxChips: 15,
                                                textStyle: TextStyle(
                                                    height: 1.5,
                                                    fontFamily: "Roboto",
                                                    fontSize: 16),
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.green)),
                                                    hintText:
                                                    'Inviter des jardiniers'),
                                                findSuggestions:
                                                    (String query) async {
                                                  queryResProfile = [];
                                                  if (query.length != 0) {
                                                    _parcelMembers = [];

                                                    var queryRes = await widget
                                                        .dataRepository
                                                        .searchByName(query);
                                                    for (int i = 0;
                                                    i <
                                                        queryRes
                                                            .documents.length;
                                                    ++i) {
                                                      var data = queryRes
                                                          .documents[i].data;
                                                      queryResProfile
                                                          .add(MemberProfile(
                                                        data["id"],
                                                        data["pseudo"],
//                                  data["email"],
//                                  'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg'
                                                      ));
                                                    }
                                                  }
                                                  return queryResProfile;
                                                },
                                                onChanged: (data) {
                                                  _parcelMembers.clear();
                                                  data.forEach((elem) {
                                                    if (elem.pseudo !=
                                                        widget.user.pseudo) {
                                                      _parcelMembers.add(
                                                          GardenMember(
                                                              id: elem.id,
                                                              pseudo:
                                                              elem.pseudo));
                                                    }
                                                  });
                                                },
                                                chipBuilder:
                                                    (context, state, profile) {
                                                  return InputChip(
                                                    key: ObjectKey(profile),
                                                    label: Text(profile.pseudo),
//                            avatar: CircleAvatar(
//                              backgroundImage: NetworkImage(profile.imageUrl),
//                            ),
                                                    onDeleted: () =>
                                                        state.deleteChip(profile),
                                                    materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                  );
                                                },
                                                suggestionBuilder:
                                                    (context, state, profile) {
                                                  return ListTile(
                                                    key: ObjectKey(profile),
//                            leading: CircleAvatar(
//                              backgroundImage: NetworkImage(profile.imageUrl),
//                            ),
                                                    title: Text(profile.pseudo),
//                            subtitle: Text(profile.email),
                                                    onTap: () =>
                                                        state.selectSuggestion(
                                                            profile),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  isActive: _currentStep >= 3,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Container(
                                    height: 50 * SizeConfig.heightMultiplier,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/empty_states/empty_garden.png',
                                          fit: BoxFit.scaleDown,
                                        ),
                                        Text("Aucune modélisation correspondante à votre recherche.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: const Color(
                                                    0xFF01534F),
                                                fontSize: 2 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                            ))
                                      ],
                                    )
                                  ),
                                  isActive: _currentStep >= 4,
                                ),
                              ],
                              controlsBuilder: _createEventControlBuilder,
                              onStepContinue: _currentStep < 5
                                  ? () => setState(() => _currentStep += 1)
                                  : null,
                              onStepCancel: _currentStep > -1
                                  ? () {
                                if (_currentStep == 4) {
                                  BlocProvider.of<ModelingsBloc>(context)
                                      .add(FetchVeggies());
                                } else {
                                  setState(() => _currentStep -= 1);
                                }
                              }
                                  : null,
                              // Using a variable here for handling the currentStep
                              currentMyStep: this._currentStep,
                              // List the steps you would like to have
                              type: MyStepperType.horizontal,
                            ),
                          ),
                        ))
                  ],
                )),
          );
        } else {
          return Scaffold(
            body: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 7 * SizeConfig.widthMultiplier,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              )),
                          Flexible(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Container(
                                  child: _currentStep == 4
                                      ? Text(
                                      "Voici les associations que nous vous conseillons !",
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: const Color(0xFF01534F),
                                        fontSize:
                                        2.5 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                      ))
                                      : Container(),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 6,
                        child: Container(
                          child: Theme(
                            data: ThemeData(
                                canvasColor: Colors.white,
                                primaryColor: Colors.green),
                            child: MyStepper(
                              steps: [
                                MyStep(
                                  title: Text(""),
                                  content: Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                Text("Créer une parcelle",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xFF01534F),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                        FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: TextField(
                                                controller: _parcelName,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0)),
                                                      borderSide: BorderSide(
                                                          color: Colors.green)),
                                                  hintText:
                                                  'Donner un nom à votre parcelle',
                                                  errorText: _parcelNameValidate
                                                      ? "Le nom d'une parcelle ne peut être vide"
                                                      : null,
                                                ),
                                                onChanged: (value) {
                                                  _parcelName.text.isEmpty
                                                      ? _parcelNameValidate = true
                                                      : _parcelNameValidate =
                                                  false;
                                                  setState(() {});
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  isActive: _currentStep >= 0,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/utils_image/bac.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Text("Dimensions en centimètres",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                    const Color(0xFF01534F),
                                                    fontSize: 2.5 *
                                                        SizeConfig.textMultiplier,
                                                    fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                                flex: 10,
                                                child: PopupMenuButton<String>(
                                                  itemBuilder: (context) {
                                                    return lengths
                                                        .map((String item) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList();
                                                  },
                                                  onSelected: (String newValue) {
                                                    setState(() {
                                                      gardenLengthValue =
                                                          newValue;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xFF01534F),
                                                          width: 0.5),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(
                                                            gardenLengthValue ==
                                                                null
                                                                ? "Longueur"
                                                                : gardenLengthValue,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF01534F),
                                                              fontSize: 2 *
                                                                  SizeConfig
                                                                      .textMultiplier,
//                          fontWeight: FontWeight.bold,
                                                            )),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 7 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          color: const Color(
                                                              0xFF01534F),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                            Spacer(),
                                            Flexible(
                                                flex: 10,
                                                child: PopupMenuButton<String>(
                                                  itemBuilder: (context) {
                                                    return widths
                                                        .map((String item) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList();
                                                  },
                                                  onSelected: (String newValue) {
                                                    setState(() {
                                                      gardenWidthValue = newValue;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xFF01534F),
                                                          width: 0.5),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(
                                                            gardenWidthValue ==
                                                                null
                                                                ? "Largeur"
                                                                : gardenWidthValue,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF01534F),
                                                              fontSize: 2 *
                                                                  SizeConfig
                                                                      .textMultiplier,
//                          fontWeight: FontWeight.bold,
                                                            )),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 7 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          color: const Color(
                                                              0xFF01534F),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      )
//
                                    ],
                                  ),
                                  isActive: _currentStep >= 1,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/utils_image/tree.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Text(
                                            "Utilisez-vous un bac de culture ?",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: const Color(0xFF01534F),
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 10,
                                              child: RadioListTile<bool>(
                                                title: const Text('Oui'),
                                                value: true,
                                                groupValue: _parcelOnBac,
                                                activeColor: Colors.green,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _parcelOnBac = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            Spacer(),
                                            Flexible(
                                              flex: 10,
                                              child: RadioListTile<bool>(
                                                title: const Text('Non'),
                                                value: false,
                                                activeColor: Colors.green,
                                                groupValue: _parcelOnBac,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _parcelOnBac = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  isActive: _currentStep >= 2,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                                        color: const Color(
                                                            0xFF01534F),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                        FontWeight.bold
//                          fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: ChipsInput(
                                                keyboardAppearance:
                                                Brightness.dark,
                                                textCapitalization:
                                                TextCapitalization.words,
                                                enabled: true,
                                                maxChips: 15,
                                                textStyle: TextStyle(
                                                    height: 1.5,
                                                    fontFamily: "Roboto",
                                                    fontSize: 16),
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.green)),
                                                    hintText:
                                                    'Inviter des jardiniers'),
                                                findSuggestions:
                                                    (String query) async {
                                                  queryResProfile = [];
                                                  if (query.length != 0) {
                                                    _parcelMembers = [];

                                                    var queryRes = await widget
                                                        .dataRepository
                                                        .searchByName(query);
                                                    for (int i = 0;
                                                    i <
                                                        queryRes
                                                            .documents.length;
                                                    ++i) {
                                                      var data = queryRes
                                                          .documents[i].data;
                                                      queryResProfile
                                                          .add(MemberProfile(
                                                        data["id"],
                                                        data["pseudo"],
//                                  data["email"],
//                                  'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg'
                                                      ));
                                                    }
                                                  }
                                                  return queryResProfile;
                                                },
                                                onChanged: (data) {
                                                  _parcelMembers.clear();
                                                  data.forEach((elem) {
                                                    if (elem.pseudo !=
                                                        widget.user.pseudo) {
                                                      _parcelMembers.add(
                                                          GardenMember(
                                                              id: elem.id,
                                                              pseudo:
                                                              elem.pseudo));
                                                    }
                                                  });
                                                },
                                                chipBuilder:
                                                    (context, state, profile) {
                                                  return InputChip(
                                                    key: ObjectKey(profile),
                                                    label: Text(profile.pseudo),
//                            avatar: CircleAvatar(
//                              backgroundImage: NetworkImage(profile.imageUrl),
//                            ),
                                                    onDeleted: () =>
                                                        state.deleteChip(profile),
                                                    materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                  );
                                                },
                                                suggestionBuilder:
                                                    (context, state, profile) {
                                                  return ListTile(
                                                    key: ObjectKey(profile),
//                            leading: CircleAvatar(
//                              backgroundImage: NetworkImage(profile.imageUrl),
//                            ),
                                                    title: Text(profile.pseudo),
//                            subtitle: Text(profile.email),
                                                    onTap: () =>
                                                        state.selectSuggestion(
                                                            profile),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  isActive: _currentStep >= 3,
                                ),
                                MyStep(
                                  title: Text(""),
                                  content: Container(
                                    height: 50 * SizeConfig.heightMultiplier,
                                    child: ListView(
                                      padding: EdgeInsets.only(top: 1.0),
                                      children:
                                      state.modelingsFetched.map((modeling) {

                                        return InkWell(
                                            onTap: () async {
                                              _parcelMembers.add(GardenMember(
                                                  id: widget.user.id,
                                                  pseudo: widget.user.pseudo));

                                              final Parcel parcel = Parcel(
                                                  _parcelName.text,
                                                  widget.garden.id,
                                                  double.parse(gardenLengthValue),
                                                  double.parse(gardenWidthValue),
                                                  _parcelOnBac,
                                                  widget.garden.publicVisibility,
                                                  '${widget.user.id}',
                                                  _parcelMembers,
                                                  '',
                                                  '',
                                                  DateTime.now(),
                                                  0, [], false);

                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider<ParcelsBloc>.value(value: parcelBloc),
                                                      ],
                                                      child: DetailsModelingScreen(
                                                          user: widget.user,
                                                          gardenId: widget.garden.id,
                                                          parcel: parcel,
                                                          modeling: modeling,
//                                                        designs: modeling.designs,
                                                          veggiesComposition: veggiesComposition
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
//                                            return Navigator.of(context).push(
//                                                MaterialPageRoute(builder: (_) {
//                                              return ;
//                                            }));
                                            },
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    child: Container(
                                                      height: 29 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: <Widget>[
                                                          Flexible(
                                                            flex: 5,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: <Widget>[
                                                                Flexible(
                                                                    flex: 2,
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      EdgeInsets.all(
                                                                          10),
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                            Color(0xFFD7D35F),
//                                                  border: Border.all(color: const Color(0xFF01534F), width: 2),
                                                                            borderRadius:
                                                                            BorderRadius.all(Radius.circular(5)),
                                                                          ),
                                                                          height: 4.5 * SizeConfig.heightMultiplier,
                                                                          child: Center(
                                                                            child: Text(
                                                                                "${modeling.name}",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  color: const Color(0xFF01534F),
                                                                                  fontSize: 1.7 * SizeConfig.textMultiplier,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                          )),
                                                                    )),
//                                      Spacer(),
                                                                Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      EdgeInsets.all(
                                                                          10),
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                            Color(0xFF4BB16C),
                                                                            borderRadius:
                                                                            BorderRadius.all(Radius.circular(5)),
                                                                          ),
                                                                          height: 4.5 * SizeConfig.heightMultiplier,
                                                                          child: Center(
                                                                            child: Text(
                                                                                "Infos",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 1.7 * SizeConfig.textMultiplier,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                          )),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 8,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: <Widget>[
                                                                Flexible(
                                                                    flex: 2,
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      EdgeInsets
                                                                          .all(5),
                                                                      child: ListView.builder(
                                                                        // TODO
                                                                          scrollDirection: Axis.horizontal,
                                                                          itemCount: modeling.composition.length,
                                                                          itemBuilder: (context, index) {

//                                                                          print(${state.veggiesComposition[modeling.composition[index]].imageName});

                                                                            return Container(
                                                                              width:
                                                                              22 * SizeConfig.widthMultiplier,
                                                                              child:
                                                                              Card(
                                                                                color: const Color(0xFFE6F1D9),
                                                                                child: Column(
//                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: <Widget>[
                                                                                    Flexible(
                                                                                      flex: 1,
                                                                                      child: Container(),
                                                                                    ),
                                                                                    Flexible(
                                                                                      flex: 4,
                                                                                      child: Image.asset(
                                                                                        "assets/veggies/${state.veggiesComposition[modeling.composition[index]].imageName}.png",
                                                                                        fit: BoxFit.scaleDown,
                                                                                      ),
                                                                                    ),
                                                                                    Flexible(
                                                                                        flex: 3,
                                                                                        child: Center(
                                                                                          child: Text("${state.veggiesComposition[modeling.composition[index]].nameFr}",
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                color: const Color(0xFF01534F),
                                                                                                fontSize: 1.4 * SizeConfig.textMultiplier,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              )),
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                              flex: 4,
                                                              child: Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                      10),
                                                                  child:
                                                                  Container(
                                                                    child: Text(
                                                                        "${modeling.descriptionFr}",
                                                                        textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                        style:
                                                                        TextStyle(
                                                                          color: const Color(
                                                                              0xFF01534F),
                                                                          fontSize:
                                                                          1.8 *
                                                                              SizeConfig.textMultiplier,
//                          fontWeight: FontWeight.bold,
                                                                        )),
                                                                  )))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )));
                                      }).toList(),
                                    ),
                                  ),
                                  isActive: _currentStep >= 4,
                                ),
                              ],
                              controlsBuilder: _createEventControlBuilder,
                              onStepContinue: _currentStep < 5
                                  ? () => setState(() => _currentStep += 1)
                                  : null,
                              onStepCancel: _currentStep > -1
                                  ? () {
                                if (_currentStep == 4) {
                                  BlocProvider.of<ModelingsBloc>(context)
                                      .add(FetchVeggies());
                                } else {
                                  setState(() => _currentStep -= 1);
                                }
                              }
                                  : null,
                              // Using a variable here for handling the currentStep
                              currentMyStep: this._currentStep,
                              // List the steps you would like to have
                              type: MyStepperType.horizontal,
                            ),
                          ),
                        ))
                  ],
                )),
          );
        }

      } else {
        return CircularProgressIndicator();
      }
    });
  }

  Widget _createEventControlBuilder(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    if (_currentStep == 0) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  if (_parcelName.text.isNotEmpty) {
                    onStepContinue();
                  } else {
                    setState(() {
                      _parcelName.text.isEmpty
                          ? _parcelNameValidate = true
                          : _parcelNameValidate = false;
                    });
                  }
                },
                child: Text('${AppLocalizations.of(context).continueButton}')),
          ]);
    } else if (_currentStep == 1) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
                onPressed: onStepCancel,
                child: Text('${AppLocalizations.of(context).backButton}')),
            RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  if (gardenWidthValue != null && gardenLengthValue != null) {
                    onStepContinue();
                  }
                },
                child: Text('${AppLocalizations.of(context).continueButton}')),
          ]);
    } else if (_currentStep == 4) {
       // TODO
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
                onPressed: onStepCancel,
                child: Text('${AppLocalizations.of(context).backButton}')),
            RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () async {
                  List<String> veggiesList = List<String>();

                  veggiesSelected.forEach((k, v) {
                    if (v) {
                      veggiesList.add(k.id);
                    }
                  });

                  BlocProvider.of<ModelingsBloc>(context)
                      .add(FetchModelings(veggiesList, veggiesComposition));
                },
                child: Text('Rechercher')),
          ]);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
                onPressed: onStepCancel,
                child: Text('${AppLocalizations.of(context).backButton}')),
            RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: onStepContinue,
                child: Text('${AppLocalizations.of(context).continueButton}')),
          ]);
    }
  }
}

class AddParcelScreenArguments {
  final Garden garden;
  final User user;

  AddParcelScreenArguments(this.garden, this.user);
}
