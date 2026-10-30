import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/application_model.dart';

class StatusTimelineWidget extends StatelessWidget {
  final List<StatusStep> steps;

  const StatusTimelineWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator Column (Circle + Vertical Line)
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.isCompleted
                          ? AppColors.forestGreen
                          : (step.isCurrent ? AppColors.surfaceWhite : AppColors.surfaceSubtle),
                      border: Border.all(
                        color: step.isCompleted
                            ? AppColors.forestGreen
                            : (step.isCurrent ? AppColors.forestGreen : AppColors.borderMedium),
                        width: step.isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: step.isCompleted
                          ? const Icon(Icons.check, size: 14, color: AppColors.surfaceWhite)
                          : (step.isCurrent
                              ? Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.forestGreen,
                                  ),
                                )
                              : Text(
                                  '${index + 1}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                                )),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: step.isCompleted ? AppColors.forestGreen : AppColors.borderLight,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Content Column
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              step.title,
                              style: AppTypography.titleSmall.copyWith(
                                color: step.isCurrent
                                    ? AppColors.forestGreen
                                    : (step.isCompleted ? AppColors.textPrimary : AppColors.textMuted),
                                fontWeight: step.isCurrent || step.isCompleted ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (step.isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.statusWarningBg,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.statusWarningBorder, width: 0.8),
                              ),
                              child: Text(
                                'Proses Aktif',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.statusWarning,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: step.isCurrent ? AppColors.textSecondary : AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                      if (step.date != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                step.date!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
