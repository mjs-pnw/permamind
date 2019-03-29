import 'package:flutter/material.dart';
import 'package:permamind_mobile/widgets/garden_dimensions.dart';
import 'package:permamind_mobile/widgets/garden_soil.dart';

class GardenDesigner extends StatefulWidget {
  @override
  GardenDesignerState createState() => new GardenDesignerState();
}

class GardenDesignerState extends State<GardenDesigner> {
  // init the step to 0th position
  int current_step = 0;
  List<Step> my_steps = [
    new Step(
      // Title of the Step
        title: new Text("Dimensions du jardin"),
        // Content, it can be any widget here. Using basic Text for this example
        content: new GardenDimensions(),
        isActive: true),
    new Step(
        title: new Text("Type de sol"),
        content: new GardenSoil()
        // You can change the style of the step icon i.e number, editing, etc.
        state: StepState.editing,
        isActive: true),
    new Step(
        title: new Text("Choisis tes légumes"),
        content: new Text("Hello World!"),
        isActive: true),
    new Step(
        title: new Text("Génération de ton jardin"),
        content: new Text("Hello World!"),
        isActive: true),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
      appBar: new AppBar(
        // Title
        title: new Text("Créer ton jardin"),
      ),
      // Body
      body: new Container(
          child: new Stepper(
            controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                Container(),
            currentStep: this.current_step,
            // List the steps you would like to have
            steps: my_steps,
            type: StepperType.vertical,
            // Know the step that is tapped
            onStepTapped: (step) {
              // On hitting step itself, change the state and jump to that step
              setState(() {
                // update the variable handling the current step value
                // jump to the tapped step
                current_step = step;
              });
              // Log function call
            },
          )),
    );
  }
}