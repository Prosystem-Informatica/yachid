import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String username;
  const HeaderWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text('Olá, $username'),
      ],
    );
  }
}
