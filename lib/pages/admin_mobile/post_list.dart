import 'package:flutter/material.dart';
import 'package:study_app_admin/pages/admin_mobile/posts_header.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [PostsHeader()],
      ),
    );
  }
}
