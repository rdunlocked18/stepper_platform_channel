import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stepper_bridge/components/completed_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stepper Bridge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Stepper Bridge'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentStep = 0;
  bool isFinished = false;
  bool isFlipped = false;
  String platformText = '';
  final methodChannelKey = 'com.stepperhit/methodChannel';

  @override
  void initState() {
    setState(() {
      _getTextViaPlatfromChannel(0);
    });
    super.initState();
  }

  void _onStepContinueClicked() {
    setState(() {
      _currentStep < 2 ? _currentStep += 1 : null;
      _getTextViaPlatfromChannel(_currentStep);
    });
  }

  void _onStepCancelClicked() {
    setState(() {
      _currentStep > 0 ? _currentStep -= 1 : null;
      _getTextViaPlatfromChannel(_currentStep);
    });
  }

  void _getTextViaPlatfromChannel(int index) async {
    debugPrint("called");
    try {
      final methodChannel = MethodChannel(methodChannelKey);
      var value = await methodChannel
          .invokeMethod('getTextForStepper', {"stepIndex": "$index"});
      debugPrint('Value $value');
      setState(() {
        platformText = '$value';
      });
    } catch (e) {
      debugPrint('Error Occured With : $e');
    }
  }

  void _onStepTapped(int index) {
    setState(() {
      _currentStep > 0 || _currentStep < 2 ? _currentStep = index : null;
      _getTextViaPlatfromChannel(index);
    });
  }

  void _onFinishedClicked() {
    setState(() {
      isFinished = true;
    });
  }

  void _resetStepper() {
    setState(() {
      isFinished = false;
      _currentStep = 0;
      _getTextViaPlatfromChannel(0);
    });
  }

  void _flipView() {
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isFinished,
            child: CompletedWidget(
              onResetClicked: _resetStepper,
            ),
          ),
          if (isFlipped && !isFinished)
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildStepper(false, 'Select Campaign settings', platformText,
                      _currentStep == 0, 0),
                  _buildStepper(false, 'Create an ad group', platformText,
                      _currentStep == 1, 1),
                  _buildStepper(
                      true, 'Create an ad', platformText, _currentStep == 2, 2),
                ],
              ),
            ),
          if (!isFlipped && !isFinished)
            Stepper(
              currentStep: _currentStep,
              elevation: 1,
              onStepContinue: _onStepContinueClicked,
              onStepCancel: _onStepCancelClicked,
              onStepTapped: (index) => _onStepTapped(index),
              type: StepperType.vertical,
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _currentStep == 2
                          ? _onFinishedClicked
                          : _onStepContinueClicked,
                      child: _currentStep < 2
                          ? const Text('Continue')
                          : const Text('Finish'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed:
                          _currentStep == 0 ? null : _onStepCancelClicked,
                      child: Text(
                        'Back',
                        style: TextStyle(
                            color:
                                _currentStep == 0 ? Colors.grey : Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
              steps: [
                Step(
                  title: const Text('Select Campaign settings'),
                  content: Text(platformText),
                  isActive: _currentStep > 0,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Create an ad group'),
                  content: Text(platformText),
                  isActive: _currentStep > 1,
                  state:
                      _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                    title: const Text('Create an ad'),
                    content: Text(platformText),
                    isActive: _currentStep == 2,
                    state: _currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                    subtitle: const Text('Last Step')),
              ],
            ),
        ],
      ),
      // body:
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _flipView,
        tooltip: 'Increment',
        icon: const Icon(Icons.flip),
        label: const Text('Custom Stepper'),
      ),
    );
  }

  Widget _buildStepper(
      bool isLast, String label, String content, bool isVisible, int index) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: _currentStep >= index
                        ? Color.fromARGB(255, 103, 128, 241)
                        : Colors.grey.shade300,
                    child: _currentStep <= index
                        ? Text('${index + 1}')
                        : const Icon(
                            Icons.check,
                          ),
                  ),
                  isLast == true
                      ? Container()
                      : Expanded(
                          child: Container(
                            height: 32,
                            width: 2.5,
                            color: Color.fromARGB(255, 103, 128, 241),
                          ),
                        )
                ],
              ),
            ],
          ),
          Visibility(
            visible: isVisible,
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: _currentStep > 1 == true ? 0 : 32, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      content,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: _currentStep == 2
                                ? _onFinishedClicked
                                : _onStepContinueClicked,
                            child: _currentStep < 2
                                ? const Text('Continue')
                                : const Text('Finish'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed:
                                _currentStep == 0 ? null : _onStepCancelClicked,
                            child: Text(
                              'Back',
                              style: TextStyle(
                                  color: _currentStep == 0
                                      ? Colors.grey
                                      : Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
