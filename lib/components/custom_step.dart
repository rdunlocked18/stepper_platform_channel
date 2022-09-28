import 'package:flutter/material.dart';
import 'package:stepper_bridge/utils/app_constants.dart';

class CustomStep extends StatelessWidget {
  final String label;
  final String content;

  final int index;
  final int currentStep;
  final VoidCallback onFinishedClicked;
  final VoidCallback onStepCancelClicked;
  final VoidCallback onStepContinueClicked;

  const CustomStep({
    super.key,
    required this.label,
    required this.content,
    required this.index,
    required this.currentStep,
    required this.onFinishedClicked,
    required this.onStepCancelClicked,
    required this.onStepContinueClicked,
  });

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: currentStep >= index
                        ? colorLightPurple
                        : Colors.grey.shade300,
                    child: currentStep <= index
                        ? Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.black),
                          )
                        : const Icon(
                            Icons.check,
                          ),
                  ),
                  index == 2
                      ? Container()
                      : Expanded(
                          child: Container(
                            height: 35,
                            width: 2.5,
                            color: colorLightPurple,
                          ),
                        )
                ],
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: currentStep > 1 == true ? 0 : 32, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (currentStep == index)
                    const SizedBox(
                      height: 20,
                    ),
                  if (currentStep == index)
                    Text(
                      content,
                    ),
                  if (currentStep == index)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: currentStep == 2
                                ? onFinishedClicked
                                : onStepContinueClicked,
                            child: currentStep < 2
                                ? const Text('Continue')
                                : const Text('Finish'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed:
                                currentStep == 0 ? null : onStepCancelClicked,
                            child: Text(
                              'Back',
                              style: TextStyle(
                                  color: currentStep == 0
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
          )
        ],
      ),
    );
  }
}
