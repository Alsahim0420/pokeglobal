import 'package:pokeglobal/core/services/pokemon_type_label_mapper.dart';
import 'package:pokeglobal/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';

/// Enriquece una lista de [PokemonCardItem] con los tipos obtenidos de GET /pokemon/{id}.
/// Ejecuta las peticiones en paralelo con concurrencia limitada para no saturar la API.
class PokemonListEnricher {
  PokemonListEnricher(this._datasource);

  final PokemonRemoteDatasource _datasource;

  /// Máximo de peticiones de detalle simultáneas.
  static const int maxConcurrent = 6;

  /// Devuelve la misma lista con [PokemonCardItem.types] rellenados.
  /// Si falla el detalle de un ítem, se deja con tipos vacíos (no rompe la lista).
  Future<List<PokemonCardItem>> enrich(List<PokemonCardItem> items) async {
    if (items.isEmpty) return items;

    final results = <PokemonCardItem>[];
    for (var i = 0; i < items.length; i += maxConcurrent) {
      final chunk = items.skip(i).take(maxConcurrent).toList();
      final futures = chunk.map(_enrichOne);
      final chunkResults = await Future.wait(futures);
      results.addAll(chunkResults);
    }
    return results;
  }

  Future<PokemonCardItem> _enrichOne(PokemonCardItem item) async {
    try {
      final detail = await _datasource.getPokemonDetail(item.id);
      final labels = PokemonTypeLabelMapper.toDisplayLabels(detail.typeNames);
      final types = labels.map((l) => PokemonTypeTag(label: l)).toList();
      return item.copyWith(types: types);
    } catch (_) {
      return item;
    }
  }
}
