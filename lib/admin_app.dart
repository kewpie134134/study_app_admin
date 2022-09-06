import 'package:flutter/material.dart';
import 'package:study_app_admin/pages/admin_mobile.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: const AdminMobilePage(),
    );
  }
}
