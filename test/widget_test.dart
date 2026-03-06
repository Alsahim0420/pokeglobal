import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/main.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/providers/settings_provider.dart';

void main() {
  testWidgets('PokeGlobalApp builds', (WidgetTester tester) async {
    final favoritesStore = InMemoryKeyValueStore();
    final settingsStore = InMemoryKeyValueStore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesStoreProvider.overrideWithValue(favoritesStore),
          settingsStoreProvider.overrideWithValue(settingsStore),
        ],
        child: const PokeGlobalApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PokeGlobalApp), findsOneWidget);
  });
}
