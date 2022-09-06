import 'package:flutter/material.dart';
import 'package:study_app_admin/components/side_navigation.dart';
import 'package:study_app_admin/pages/admin_mobile/post_list.dart';

class AdminMobilePage extends StatelessWidget {
  const AdminMobilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: const [
        SideNavigation(),
        VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: PostList(),
        ),
      ]),
    );
  }
}
