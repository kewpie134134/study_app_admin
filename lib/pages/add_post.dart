import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_app_admin/provider/chat.dart';

// ConsumeWieget で Provider から値を受け渡す
class AddPostPage extends ConsumerWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    // Provider から値を受け取る
    final user = ref.watch(userProvider);
    final messageText = ref.watch(messageTextProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("チャット投稿"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "投稿メッセージ"),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (String value) {
                  // Provider から値を更新
                  ref.read(messageTextProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("投稿"),
                  onPressed: () async {
                    final date = DateTime.now().toLocal().toIso8601String();
                    final email = user!.email;
                    await FirebaseFirestore.instance
                        .collection("posts")
                        .doc()
                        .set({
                      "text": messageText,
                      "email": email,
                      "date": date
                    });
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
