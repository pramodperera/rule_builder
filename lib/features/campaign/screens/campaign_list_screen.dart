import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final _searchCtrl = TextEditingController();

  // Temporary UI-only mock items so the app looks real.
  // Later this comes from API via a controller.
  final List<_CampaignItem> _mockCampaigns = const [
    _CampaignItem(
      name: 'EXTERNAL_AGENT_SETTLEMENT',
      status: 'Published',
      updatedAt: '2026-02-16',
    ),
    _CampaignItem(
      name: 'DPD_30_60_ACTIVE_PTP',
      status: 'Draft',
      updatedAt: '2026-02-15',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter mock list by search text (simple UI behavior).
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _mockCampaigns
        : _mockCampaigns
              .where((c) => c.name.toLowerCase().contains(query))
              .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top header section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row + Create button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Campaigns',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => context.goNamed('ruleBuilder'),
                        icon: const Icon(Icons.add),
                        label: const Text('Create'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Subheading
                  Text(
                    'Build and publish campaign logic without writing SQL.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black.withOpacity(0.60),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search bar
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search campaigns (e.g. EXTERNAL_AGENT...)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear',
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Content area
            Expanded(
              child: filtered.isEmpty
                  ? _EmptyState(onCreate: () => context.goNamed('ruleBuilder'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _CampaignCard(
                          item: item,
                          onTap: () {
                            // Later: open details / edit screen.
                            // For now: open rule builder.
                            context.goNamed('ruleBuilder');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------
/// UI widgets (kept in same file for now)
/// ----------------------

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.item, required this.onTap});

  final _CampaignItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = item.status == 'Published'
        ? Colors.green.withOpacity(0.15)
        : Colors.orange.withOpacity(0.15);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left icon box
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.campaign, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),

              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      'Last updated: ${item.updatedAt}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withOpacity(0.55),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.status,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Arrow
              Icon(Icons.chevron_right, color: Colors.black.withOpacity(0.35)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No campaigns yet', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Create your first campaign rule set using the drag rule builder.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withOpacity(0.60),
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Campaign'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Temporary UI model (replace later with real model from API)
class _CampaignItem {
  final String name;
  final String status;
  final String updatedAt;

  const _CampaignItem({
    required this.name,
    required this.status,
    required this.updatedAt,
  });
}
