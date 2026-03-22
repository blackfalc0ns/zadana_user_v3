import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final List<ProgressStep> steps;

  const ProgressIndicatorWidget({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md, horizontal: Spacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: List.generate(
          steps.length * 2 - 1,
          (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              return _ProgressStepWidget(step: steps[stepIndex]);
            } else {
              final lineIndex = index ~/ 2;
              return _ProgressLineWidget(
                isActive: steps[lineIndex].isCompleted,
              );
            }
          },
        ),
      ),
    );
  }
}

class ProgressStep {
  final String title;
  final bool isActive;
  final bool isCompleted;

  const ProgressStep({
    required this.title,
    required this.isActive,
    required this.isCompleted,
  });
}

class _ProgressStepWidget extends StatelessWidget {
  final ProgressStep step;

  const _ProgressStepWidget({required this.step});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: step.isCompleted
                  ? colors.secondary
                  : step.isActive
                      ? colors.primary
                      : colors.surfaceContainerHighest,
              shape: BoxShape.circle,
              boxShadow: step.isActive || step.isCompleted
                  ? [
                      BoxShadow(
                        color: (step.isCompleted ? colors.secondary : colors.primary)
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              step.isCompleted ? Icons.check_rounded : Icons.circle,
              color: step.isCompleted || step.isActive
                  ? colors.onPrimary
                  : colors.onSurfaceVariant,
              size: step.isCompleted ? 18 : 8,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            step.title,
            style: getMediumStyle(
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
              color: step.isActive || step.isCompleted
                  ? colors.onSurface
                  : colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLineWidget extends StatelessWidget {
  final bool isActive;

  const _ProgressLineWidget({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: Spacing.sm),
        decoration: BoxDecoration(
          color: isActive ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}
