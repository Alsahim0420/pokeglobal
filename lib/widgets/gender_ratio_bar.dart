import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';

class GenderRatioBar extends StatelessWidget {
  const GenderRatioBar({
    super.key,
    required this.malePercent,
    required this.femalePercent,
  });

  final double malePercent;
  final double femalePercent;

  @override
  Widget build(BuildContext context) {
    final total = malePercent + femalePercent;
    final maleFraction = total > 0 ? malePercent / total : 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'GENERO',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: AppColors.grey75,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Container(
                      width: constraints.maxWidth * maleFraction,
                      height: 10,
                      color: AppColors.genderMale,
                    ),
                    Container(
                      width: constraints.maxWidth * (1 - maleFraction),
                      height: 10,
                      color: AppColors.genderFemale,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.male, size: 18, color: AppColors.grey75),
                const SizedBox(width: 6),
                Text(
                  _formatPercent(malePercent),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey75,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.female, size: 18, color: AppColors.grey75),
                const SizedBox(width: 6),
                Text(
                  _formatPercent(femalePercent),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey75,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static String _formatPercent(double value) {
    if (value == value.roundToDouble()) {
      return '${value.round()}%';
    }
    return '${value.toStringAsFixed(1)}%';
  }
}
