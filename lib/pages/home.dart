import 'package:flutter/material.dart';
import '../theme.dart';
import 'registration.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(
            child: FloatingActionButton.extended(
              icon: const Icon(Icons.app_registration_rounded),
              label: const Text('Register'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Registration(title: 'Registration');
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
