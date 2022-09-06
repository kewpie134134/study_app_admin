import 'package:flutter/material.dart';
import 'package:study_app_admin/components/side_navigation.dart';

class AdminMobilePage extends StatelessWidget {
  const AdminMobilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: const [
        SideNavigation(),
      ]),
    );
  }
}
