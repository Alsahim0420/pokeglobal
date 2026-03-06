import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/l10n/type_label_helper.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/widgets/primary_button.dart';

/// Modal de filtro por tipo. Devuelve lista de nombres de tipo de la API (ej. fire, water).
Future<List<String>?> showFilterTypeModal(
  BuildContext context, {
  List<String> initialSelectedApiNames = const [],
}) async {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _FilterTypeModalContent(
      initialSelectedApiNames: initialSelectedApiNames,
    ),
  );
}

class _FilterTypeModalContent extends StatefulWidget {
  const _FilterTypeModalContent({this.initialSelectedApiNames = const []});

  final List<String> initialSelectedApiNames;

  @override
  State<_FilterTypeModalContent> createState() =>
      _FilterTypeModalContentState();
}

class _FilterTypeModalContentState extends State<_FilterTypeModalContent> {
  late Set<String> _selectedApiNames;
  bool _typeExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedApiNames = Set<String>.from(widget.initialSelectedApiNames);
  }

  void _toggle(String apiName) {
    setState(() {
      if (_selectedApiNames.contains(apiName)) {
        _selectedApiNames.remove(apiName);
      } else {
        _selectedApiNames.add(apiName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        mainAxisSize: MainAxisSize.max,
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
              l10n.filterTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: ExpansionTile(
                  initiallyExpanded: _typeExpanded,
                  expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                  onExpansionChanged: (expanded) {
                    setState(() => _typeExpanded = expanded);
                  },
                  title: Text(
                    l10n.filterType,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  children: apiTypeNames.map((apiName) {
                    final displayLabel = typeLabel(context, apiName);
                    final isSelected = _selectedApiNames.contains(apiName);
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggle(apiName),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(displayLabel)),
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  onPressed: () =>
                      Navigator.of(context).pop(_selectedApiNames.toList()),
                  label: l10n.filterApply,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    foregroundColor: colorScheme.onSurfaceVariant,
                  ),
                  child: Text(l10n.filterCancel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
