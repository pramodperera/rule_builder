import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final _searchCtrl = TextEditingController();

  // UI-only mock data so the app looks real.
  // Later: replace with Riverpod + API.
  final List<_CampaignItem> _items = const [
    _CampaignItem(
      code: 'PR_ACCOUNTS',
      title: 'PR Accounts',
      status: 'Published',
      updatedAt: '2026-03-01',
    ),
    _CampaignItem(
      code: 'EXTERNAL_AGENT_SETTLEMENT',
      title: 'External Agent Settlement',
      status: 'Draft',
      updatedAt: '2026-02-26',
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

    final q = _searchCtrl.text.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _items
        : _items
              .where(
                (c) =>
                    c.code.toLowerCase().contains(q) ||
                    c.title.toLowerCase().contains(q),
              )
              .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header block
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    'Configure campaign allocation rules without writing SQL.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black.withOpacity(0.60),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search by code or title (e.g. PR_ACCOUNTS)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: q.isEmpty
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

            // Content
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
                            // Later: open edit wizard with this campaign code.
                            // For now: open rule builder directly.
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
/// Local UI Widgets
/// ----------------------

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.item, required this.onTap});

  final _CampaignItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final badgeColor = item.status == 'Published'
        ? Colors.green.withOpacity(0.14)
        : Colors.orange.withOpacity(0.16);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.code, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withOpacity(0.65),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.status,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Updated: ${item.updatedAt}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

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
                Text('No campaigns found', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Create your first campaign. You can define products, sections, and rules.',
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

/// Temporary UI-only model
class _CampaignItem {
  final String code;
  final String title;
  final String status;
  final String updatedAt;

  const _CampaignItem({
    required this.code,
    required this.title,
    required this.status,
    required this.updatedAt,
  });
}
