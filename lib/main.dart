import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider を使い、受け渡すデータを定義する
// ※ Provider の種類は複数あるが、ここではデータを更新できる StateProvider を使う
final countProvider = StateProvider((ref) {
  return 0;
});

void main() {
  runApp(
      // Riverpod でデータを受け渡しが可能な状態にするために必要
      const ProviderScope(child: MyApp()));
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// ConsumerWidget を使うと build() からデータを受け取ることができる
class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch()を使いデータを受け取る
    // 値は.stateに入っている
    // 値は更新されたら自動的に反映される
    final count = ref.watch(countProvider);

    return Scaffold(
      body: Center(
        child: Text('count is $count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read(countProvider).state に値を代入することで更新できる
          // また、ボタンタップ時などは、context.read() を使うことで無駄な再描画を減らせる
          ref.read(countProvider.state).state += 1;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
