import 'package:flutter/material.dart';
import 'package:study_app_admin/pages/chat/admin_mobile.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "NotoSansJP",
      ),
      home: const AdminMobilePage(),
    );
  }
}
