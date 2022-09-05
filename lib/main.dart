import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/config.dart';

// Firebase のシークレット情報を取得
final Configurations configurations = Configurations();

// StateProvider を使い、ユーザー情報を受け渡すデータを定義する
// ※ Provider の種類は複数あるが、ここではデータを更新できる StateProvider を使う
final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

// エラー情報の受け渡しを行うための Provider
// ※ autoDispose をつけることで自動的に値をリセットすることができる
final infoTextProvider = StateProvider.autoDispose((ref) {
  return "";
});

// メールアドレスの受け渡しを行うための Provider
// ※ autoDispose をつけることで自動的に値をリセットすることができる
final emailProvider = StateProvider.autoDispose((ref) {
  return "";
});

// パスワードの受け渡しを行うための Provider
// ※ autoDispose をつけることで自動的に値をリセットすることができる
final passwordProvider = StateProvider.autoDispose((ref) {
  return "";
});

// メッセージの受け渡しを行うための Provider
// ※ autoDispose をつけることで自動的に値をリセットすることができる
final messageTextProvider = StateProvider.autoDispose((ref) {
  return "";
});

// StreamProvier を使うことで Stream も扱うことができる
// ※ autoDispose をつけることで自動的に値をリセットすることができる
final postsQueryProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection("posts")
      .orderBy("date")
      .snapshots();
});

void main() async {
  // Flutter Engine を利用する際の宣言（Firebase を利用する際は必要）
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: configurations.apiKey,
    authDomain: configurations.authDomain,
    projectId: configurations.projectId,
    // storageBucket: configurations.storageBucket, // なぜか動かない？
    messagingSenderId: configurations.messagingSenderId,
    appId: configurations.appId,
    measurementId: configurations.measurementId,
  ));
  runApp(
    // Riverpod でデータを受け渡しが可能な状態にするために必要
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

// ConsumerWidget を使うと build() からデータを受け取ることができる
class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider から値を受け取る
    final infoText = ref.watch(infoTextProvider);
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  // Provider から値を更新
                  ref.read(emailProvider.notifier).state = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  // Provider から値を更新
                  ref.read(passwordProvider.notifier).state = value;
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("ユーザー登録"),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー情報を更新
                      ref.read(userProvider.notifier).state = result.user;
                    } catch (e) {
                      // Provider から値を更新
                      ref.read(infoTextProvider.notifier).state =
                          "登録に失敗しました: ${e.toString()}";
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: const Text("ログイン"),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return const ChatPage();
                        }),
                      );
                    } catch (e) {
                      // Provider から値を更新
                      ref.read(infoTextProvider.notifier).state =
                          "ログインに失敗しました: ${e.toString()}";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ConsumerWidget で Provider から値を受け渡す
class ChatPage extends ConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider から値を受け取る
    final User user = ref.watch(userProvider.notifier).state!;
    final AsyncValue<QuerySnapshot> asyncPostsQuery =
        ref.watch(postsQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text("ログイン情報: ${user.email}"),
          ),
          Expanded(
            // StreamProvider から受け取った値は .when() で状態に応じて出し分けできる
            child: asyncPostsQuery.when(
              // 値が取得できたとき
              data: (QuerySnapshot query) {
                return ListView(
                  children: query.docs.map((document) {
                    return Card(
                      child: ListTile(
                        title: Text(document["text"]),
                        subtitle: Text(document["email"]),
                        trailing: document["email"] == user.email
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // 投稿メッセージのドキュメントを削除
                                  await FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(document.id)
                                      .delete();
                                },
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                );
              },
              // 値が読み込み中の時
              loading: () {
                return const Center(
                  child: Text("読み込み中..."),
                );
              },
              // 値の取得に失敗したとき
              error: (error, stackTrace) {
                return Center(
                  child: Text(error.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const AddPostPage();
            }),
          );
        },
      ),
    );
  }
}

// ConsumeWieget で Provider から値を受け渡す
class AddPostPage extends ConsumerWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
