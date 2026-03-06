import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_detail_use_case.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';
import 'package:pokeglobal/models/pokemon_list_result.dart';

void main() {
  group('GetPokemonDetailUseCase', () {
    test(
      'devuelve success con detalle cuando el repo devuelve entidad',
      () async {
        final detail = PokemonDetail(
          id: 1,
          name: 'Bulbasaur',
          number: 'N°001',
          typeLabels: const ['Planta', 'Veneno'],
          description: 'Desc',
          weightKg: 6.9,
          heightM: 0.7,
          category: 'Semilla',
          ability: 'Espesura',
          genderMalePercent: 87.5,
          genderFemalePercent: 12.5,
          weaknessLabels: const ['Fuego', 'Psíquico'],
          spriteUrl: 'https://example.com/1.png',
          nameSlug: 'bulbasaur',
        );
        final repo = _FakeRepo(detail: detail);
        final useCase = GetPokemonDetailUseCase(repo);
        final params = GetPokemonDetailParams('bulbasaur');

        final response = await useCase(params);

        response.when(
          success: (d) {
            expect(d.id, 1);
            expect(d.name, 'Bulbasaur');
            expect(d.number, 'N°001');
          },
          failure: (_, __) => fail('Expected success'),
        );
      },
    );

    test('devuelve failure cuando el repo lanza', () async {
      final repo = _FakeRepo(throwError: Exception('Network error'));
      final useCase = GetPokemonDetailUseCase(repo);
      final params = GetPokemonDetailParams('unknown');

      final response = await useCase(params);

      response.when(
        success: (_) => fail('Expected failure'),
        failure: (msg, _) => expect(msg, contains('Network error')),
      );
    });
  });
}

class _FakeRepo implements PokemonRepository {
  _FakeRepo({PokemonDetail? detail, Exception? throwError})
    : _detail = detail,
      _throwError = throwError;

  final PokemonDetail? _detail;
  final Exception? _throwError;

  @override
  Future<PokemonDetail> getPokemonDetail(String name) async {
    if (_throwError != null) throw _throwError;
    return _detail!;
  }

  @override
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool enrich = true,
  }) async {
    return const PokemonListResult(list: [], totalCount: 0);
  }

  @override
  Future<List<PokemonCardItem>> enrichPokemonList(
    List<PokemonCardItem> items,
  ) async {
    return items;
  }

  @override
  Future<List<PokemonCardItem>> getPokemonListByTypes(
    List<String> displayTypeLabels,
  ) async {
    return [];
  }
}
