import 'package:flutter/material.dart';

class GraphLabel extends StatelessWidget {
  const GraphLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 5,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Expence'),
          ],
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 5,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Revenue'),
          ],
        ),
      ],
    );
  }
}
