import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/services/pokemon_type_label_mapper.dart';
import 'package:pokeglobal/widgets/primary_button.dart';

/// Modal de filtro por tipo. Muestra checkboxes para cada tipo y botones Aplicar / Cancelar.
/// Al pulsar Aplicar devuelve la lista de tipos seleccionados (labels en español).
/// Al pulsar Cancelar o X devuelve null.
Future<List<String>?> showFilterTypeModal(
  BuildContext context, {
  List<String> initialSelected = const [],
}) async {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        _FilterTypeModalContent(initialSelected: initialSelected),
  );
}

class _FilterTypeModalContent extends StatefulWidget {
  const _FilterTypeModalContent({this.initialSelected = const []});

  final List<String> initialSelected;

  @override
  State<_FilterTypeModalContent> createState() =>
      _FilterTypeModalContentState();
}

class _FilterTypeModalContentState extends State<_FilterTypeModalContent> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelected);
  }

  void _toggle(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final types = PokemonTypeLabelMapper.allDisplayLabels;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: maxHeight,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            color: AppColors.transparentWhite,
            width: double.infinity,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: AppColors.transparentWhite,
            width: double.infinity,
            child: Text(
              'Filtra por tus preferencias',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Tipo',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: types.map((label) {
                  final isSelected = _selected.contains(label);
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _toggle(label),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text(label)),
                            Icon(
                              isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () => Navigator.of(context).pop(_selected.toList()),
            label: 'Aplicar',
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
