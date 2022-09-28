import 'package:flutter/material.dart';

class CompletedWidget extends StatelessWidget {
  final VoidCallback onResetClicked;
  const CompletedWidget({
    super.key,
    required this.onResetClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Ad Posted !',
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: onResetClicked,
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
