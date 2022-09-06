import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_app_admin/chat_app.dart';
import 'config/config.dart';

// Firebase のシークレット情報を取得
final Configurations configurations = Configurations();

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
      child: ChatApp(),
    ),
  );
}
