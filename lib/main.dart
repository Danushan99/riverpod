import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

extension OriginalInfexAdition<T extends num> on T? {
  T? operator +(T? others) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (others ?? 0) as T;
    } else {
      return null;
    }
  }
}

//notifier
class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  // void incremennt() => state++;
  void incremennt() => state = state == null ? 1 : state + 1;
  int? get value => state;
}

//provider
final CounterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(CounterProvider);
              final pressValue =
                  count == null ? 'press add button' : count.toString();
              return Text(pressValue);
            },
          ),
          TextButton(
              onPressed: ref.read(CounterProvider.notifier).incremennt,
              child: Text(
                "Add",
              ))
        ],
      )),
    );
  }
}
