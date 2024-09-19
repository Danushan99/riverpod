import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_ex_1/enum.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
      ),
      showSemanticsDebugger: false,
      home: const HomePage(),
    );
  }
}

const names = ['dhanu', 'shan', 'shaniya', 'thazan', 'suja', 'latha', 'kirosh'];

final tickerProvider = StreamProvider(
    (ref) => Stream.periodic(const Duration(seconds: 1), (i) => i + 1));

// final namesProvider = StreamProvider((ref)=> ref.watch(tickerProvider.stream).map(count) => names.getRange(0,count,),);
final namesProvider =
    StreamProvider((ref) => ref.watch(tickerProvider.stream).map((count) {
          final validCount = count > names.length ? names.length : count;
          return names.getRange(0, validCount).toList();
        }));

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("steam provider"),
      ),
      body: names.when(
        data: (names) {
          return ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(names.elementAt(index)),
                );
              });
        },
        error: (Error, StackTrace) => Text("error"),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
