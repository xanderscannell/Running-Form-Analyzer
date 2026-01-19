import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/joint.dart';
import '../../core/constants/joint_constants.dart';

/// Provider for joint visibility configuration
final jointVisibilityProvider =
    StateProvider<Map<JointType, bool>>((ref) => JointConstants.defaultVisibility);

class JointConfigScreen extends ConsumerWidget {
  const JointConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibilityMap = ref.watch(jointVisibilityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Joint Settings'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(jointVisibilityProvider.notifier).state =
                  Map.from(JointConstants.defaultVisibility);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Configure which joints are displayed in the skeleton overlay.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),

          // Build sections for each category
          for (final category in JointCategory.values) ...[
            _CategorySection(
              category: category,
              visibilityMap: visibilityMap,
              onToggleCategory: (isVisible) {
                final joints = JointConstants.getJointsInCategory(category);
                final newMap = Map<JointType, bool>.from(visibilityMap);
                for (final joint in joints) {
                  newMap[joint] = isVisible;
                }
                ref.read(jointVisibilityProvider.notifier).state = newMap;
              },
              onToggleJoint: (jointType, isVisible) {
                final newMap = Map<JointType, bool>.from(visibilityMap);
                newMap[jointType] = isVisible;
                ref.read(jointVisibilityProvider.notifier).state = newMap;
              },
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final JointCategory category;
  final Map<JointType, bool> visibilityMap;
  final Function(bool) onToggleCategory;
  final Function(JointType, bool) onToggleJoint;

  const _CategorySection({
    required this.category,
    required this.visibilityMap,
    required this.onToggleCategory,
    required this.onToggleJoint,
  });

  @override
  Widget build(BuildContext context) {
    final jointsInCategory = JointConstants.getJointsInCategory(category);
    final visibleCount = jointsInCategory
        .where((j) => visibilityMap[j] == true)
        .length;
    final allVisible = visibleCount == jointsInCategory.length;
    final someVisible = visibleCount > 0 && !allVisible;

    return Card(
      child: ExpansionTile(
        leading: Checkbox(
          value: allVisible ? true : (someVisible ? null : false),
          tristate: true,
          onChanged: (value) {
            onToggleCategory(value ?? false);
          },
        ),
        title: Text(JointConstants.getCategoryDisplayName(category)),
        subtitle: Text(
          '$visibleCount of ${jointsInCategory.length} visible',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          for (final jointType in jointsInCategory)
            CheckboxListTile(
              value: visibilityMap[jointType] ?? true,
              onChanged: (value) {
                onToggleJoint(jointType, value ?? true);
              },
              title: Text(JointConstants.getJointDisplayName(jointType)),
              dense: true,
            ),
        ],
      ),
    );
  }
}
