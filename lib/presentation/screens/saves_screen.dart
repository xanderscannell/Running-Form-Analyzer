import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/saved_analysis.dart';
import '../../data/repositories/saves_repository.dart';
import '../widgets/saves/saved_analysis_card.dart';
import 'analysis_screen.dart';

/// Provider for the saves repository
final savesRepositoryProvider = Provider<SavesRepository>((ref) {
  return SavesRepository();
});

/// Provider for loading saved analyses
final savedAnalysesProvider = FutureProvider<List<SavedAnalysis>>((ref) async {
  final repository = ref.watch(savesRepositoryProvider);
  return repository.getAllSaves();
});

/// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Screen displaying all saved analyses
class SavesScreen extends ConsumerStatefulWidget {
  const SavesScreen({super.key});

  @override
  ConsumerState<SavesScreen> createState() => _SavesScreenState();
}

class _SavesScreenState extends ConsumerState<SavesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Refresh saves list when screen is opened
    Future.microtask(() => ref.invalidate(savedAnalysesProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savesAsync = ref.watch(savedAnalysesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Analyses'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search athletes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          // Saves list
          Expanded(
            child: savesAsync.when(
              data: (saves) {
                // Filter by search query
                final filteredSaves = searchQuery.isEmpty
                    ? saves
                    : saves
                        .where((s) => s.athleteName
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                if (filteredSaves.isEmpty) {
                  return _buildEmptyState(searchQuery.isNotEmpty);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(savedAnalysesProvider);
                  },
                  child: ListView.builder(
                    itemCount: filteredSaves.length,
                    itemBuilder: (context, index) {
                      final analysis = filteredSaves[index];
                      return SavedAnalysisCard(
                        analysis: analysis,
                        onTap: () => _openAnalysis(analysis),
                        onEditName: () => _showEditNameDialog(analysis),
                        onDelete: () => _showDeleteConfirmation(analysis),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading saves: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(savedAnalysesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.folder_open,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'No athletes found matching your search'
                : 'No saved analyses yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          if (!isSearching) ...[
            const SizedBox(height: 8),
            Text(
              'Analyze a running photo and save it to see it here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openAnalysis(SavedAnalysis analysis) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnalysisScreen(
          imagePath: analysis.imagePath,
          savedAnalysis: analysis,
        ),
      ),
    );
    // Refresh saves list when returning from analysis screen
    ref.invalidate(savedAnalysesProvider);
  }

  Future<void> _showEditNameDialog(SavedAnalysis analysis) async {
    final controller = TextEditingController(text: analysis.athleteName);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Athlete Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Athlete Name',
            hintText: 'Enter athlete name',
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (newName != null && newName.isNotEmpty && newName != analysis.athleteName) {
      final repository = ref.read(savesRepositoryProvider);
      await repository.updateAthleteName(analysis.id, newName);
      ref.invalidate(savedAnalysesProvider);
    }
  }

  Future<void> _showDeleteConfirmation(SavedAnalysis analysis) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Analysis'),
        content: Text(
          'Are you sure you want to delete the analysis for "${analysis.athleteName}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(savesRepositoryProvider);
      await repository.deleteAnalysis(analysis.id);
      ref.invalidate(savedAnalysesProvider);
    }
  }
}
