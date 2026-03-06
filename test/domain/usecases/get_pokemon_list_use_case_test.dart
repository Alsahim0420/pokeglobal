import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';
import 'package:pokeglobal/data/models/pokemon_list_result.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_use_case.dart';

void main() {
  group('GetPokemonListUseCase', () {
    test('devuelve success con resultado cuando el repo devuelve', () async {
      final result = PokemonListResult(list: [], totalCount: 100);
      final repo = _FakeRepo(listResult: result);
      final useCase = GetPokemonListUseCase(repo);
      final response = await useCase(
        const GetPokemonListParams(limit: 20, offset: 0),
      );

      response.when(
        success: (r) {
          expect(r.totalCount, 100);
          expect(r.list, isEmpty);
        },
        failure: (_, __) => fail('Expected success'),
      );
    });

    test('devuelve failure cuando el repo lanza', () async {
      final repo = _FakeRepo(throwError: Exception('Network'));
      final useCase = GetPokemonListUseCase(repo);
      final response = await useCase(const GetPokemonListParams());

      response.when(
        success: (_) => fail('Expected failure'),
        failure: (msg, _) => expect(msg, contains('Network')),
      );
    });

    test('pasa limit y offset al repo', () async {
      final repo = _FakeRepo(
        listResult: const PokemonListResult(list: [], totalCount: 0),
      );
      final useCase = GetPokemonListUseCase(repo);
      await useCase(const GetPokemonListParams(limit: 10, offset: 5));
      expect(repo.lastLimit, 10);
      expect(repo.lastOffset, 5);
    });
  });
}

class _FakeRepo implements PokemonRepository {
  _FakeRepo({PokemonListResult? listResult, Exception? throwError})
    : _listResult = listResult,
      _throwError = throwError;

  final PokemonListResult? _listResult;
  final Exception? _throwError;
  int? lastLimit;
  int? lastOffset;

  @override
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool enrich = true,
  }) async {
    lastLimit = limit;
    lastOffset = offset;
    if (_throwError != null) throw _throwError;
    return _listResult!;
  }

  @override
  Future<PokemonDetail> getPokemonDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<List<PokemonCardItem>> enrichPokemonList(
    List<PokemonCardItem> items,
  ) async => items;

  @override
  Future<List<PokemonCardItem>> getPokemonListByTypes(
    List<String> displayTypeLabels,
  ) async => [];
}
