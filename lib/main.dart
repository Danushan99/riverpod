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

typedef WetherEmoji = String;
const unKnownWetherEmoji = '🤷';

Future<WetherEmoji> getWether(City city) {
  return Future.delayed(
    const Duration(seconds: 2),
    () =>
        {
          City.batticaloa: '🌦️',
          City.jaffna: '🌧️',
          City.colombo: '🌧️',
          City.kandy: '☀️'
        }[city] ??
        unKnownWetherEmoji,
  );
}

final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

final wetherProvider = FutureProvider<WetherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWether(city);
  } else {
    return Future.value(unKnownWetherEmoji);
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWether = ref.watch(wetherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Column(
        children: [
          currentWether.when(
            data: (data) => Text(
              data,
              style: const TextStyle(fontSize: 40),
            ),
            error: (_, __) => const Text("Error"),
            loading: () => const Padding(
              padding: EdgeInsets.all(18.0),
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: City.values.length,
            itemBuilder: (context, index) {
              final city = City.values[index];
              final isSelected = city == ref.watch(currentCityProvider);
              return ListTile(
                  title: Text(city.toString().split('.').last),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () => ref
                      .read(
                        currentCityProvider.notifier,
                      )
                      .state = city);
            },
          ))
        ],
      ),
    );
  }
}
