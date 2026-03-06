import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';
import 'package:pokeglobal/data/models/pokemon_list_result.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/domain/usecases/enrich_pokemon_list_use_case.dart';

void main() {
  group('EnrichPokemonListUseCase', () {
    test(
      'devuelve success con lista enriquecida cuando el repo devuelve',
      () async {
        const input = PokemonCardItem(
          id: 1,
          number: 'N°001',
          name: 'B',
          nameSlug: 'b',
          types: [],
          spriteUrl: '',
        );
        const enriched = PokemonCardItem(
          id: 1,
          number: 'N°001',
          name: 'B',
          nameSlug: 'b',
          types: [PokemonTypeTag(label: 'Planta')],
          spriteUrl: '',
        );
        final repo = _FakeRepo(enrichedList: [enriched]);
        final useCase = EnrichPokemonListUseCase(repo);
        final response = await useCase(
          const EnrichPokemonListParams(items: [input]),
        );

        response.when(
          success: (r) {
            expect(r.length, 1);
            expect(r.first.types.first.label, 'Planta');
          },
          failure: (_, __) => fail('Expected success'),
        );
      },
    );

    test('devuelve failure cuando el repo lanza', () async {
      final repo = _FakeRepo(throwError: Exception('Enrich failed'));
      final useCase = EnrichPokemonListUseCase(repo);
      final response = await useCase(
        const EnrichPokemonListParams(
          items: [
            PokemonCardItem(
              id: 1,
              number: '',
              name: '',
              nameSlug: '',
              types: [],
              spriteUrl: '',
            ),
          ],
        ),
      );

      response.when(
        success: (_) => fail('Expected failure'),
        failure: (msg, _) => expect(msg, contains('Enrich failed')),
      );
    });
  });
}

class _FakeRepo implements PokemonRepository {
  _FakeRepo({List<PokemonCardItem>? enrichedList, Exception? throwError})
    : _enrichedList = enrichedList,
      _throwError = throwError;

  final List<PokemonCardItem>? _enrichedList;
  final Exception? _throwError;

  @override
  Future<List<PokemonCardItem>> enrichPokemonList(
    List<PokemonCardItem> items,
  ) async {
    if (_throwError != null) throw _throwError;
    return _enrichedList ?? items;
  }

  @override
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool enrich = true,
  }) async => throw UnimplementedError();

  @override
  Future<PokemonDetail> getPokemonDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<List<PokemonCardItem>> getPokemonListByTypes(
    List<String> typeApiNames,
  ) async => throw UnimplementedError();
}
