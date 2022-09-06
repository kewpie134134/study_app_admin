import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
