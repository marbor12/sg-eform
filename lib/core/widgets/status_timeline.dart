import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum StepState { done, now, todo }

class TimelineStep {
  const TimelineStep(this.state, this.title, this.sub);

  final StepState state;
  final String title;
  final String sub;
}

class StatusTimeline extends StatelessWidget {
  const StatusTimeline(this.steps, {super.key});

  final List<TimelineStep> steps;

  Widget _dot(StepState s) {
    switch (s) {
      case StepState.done:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      case StepState.now:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: 6),
          ),
        );
      case StepState.todo:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.dotTodo, width: 2),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 22,
                  child: Column(
                    children: [
                      _dot(steps[i].state),
                      if (i != steps.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: steps[i].state == StepState.done
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: steps[i].state == StepState.todo
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: steps[i].state == StepState.todo
                                ? AppColors.muted
                                : AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          steps[i].sub,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}