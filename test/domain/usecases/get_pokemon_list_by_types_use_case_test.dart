import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';
import 'package:pokeglobal/data/models/pokemon_list_result.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_by_types_use_case.dart';

void main() {
  group('GetPokemonListByTypesUseCase', () {
    test('devuelve success con lista cuando el repo devuelve', () async {
      const list = [
        PokemonCardItem(
          id: 1,
          number: 'N°001',
          name: 'Bulbasaur',
          nameSlug: 'bulbasaur',
          types: [PokemonTypeTag(label: 'Planta')],
          spriteUrl: '',
        ),
      ];
      final repo = _FakeRepo(typesResult: list);
      final useCase = GetPokemonListByTypesUseCase(repo);
      final response = await useCase(['grass']);

      response.when(
        success: (r) {
          expect(r.length, 1);
          expect(r.first.name, 'Bulbasaur');
        },
        failure: (_, __) => fail('Expected success'),
      );
    });

    test('devuelve failure cuando el repo lanza', () async {
      final repo = _FakeRepo(throwError: Exception('API error'));
      final useCase = GetPokemonListByTypesUseCase(repo);
      final response = await useCase(['fire']);

      response.when(
        success: (_) => fail('Expected failure'),
        failure: (msg, _) => expect(msg, contains('API error')),
      );
    });
  });
}

class _FakeRepo implements PokemonRepository {
  _FakeRepo({List<PokemonCardItem>? typesResult, Exception? throwError})
    : _typesResult = typesResult,
      _throwError = throwError;

  final List<PokemonCardItem>? _typesResult;
  final Exception? _throwError;

  @override
  Future<List<PokemonCardItem>> getPokemonListByTypes(
    List<String> typeApiNames,
  ) async {
    if (_throwError != null) throw _throwError;
    return _typesResult ?? [];
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
  Future<List<PokemonCardItem>> enrichPokemonList(
    List<PokemonCardItem> items,
  ) async => throw UnimplementedError();
}
