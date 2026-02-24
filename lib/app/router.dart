import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import './campaign_list_screen.dart';
import '../features/rule_builder/screens/rule_builder_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'campaignList',
        builder: (context, state) => const CampaignListScreen(),
      ),
      GoRoute(
        path: '/rule-builder',
        name: 'ruleBuilder',
        builder: (context, state) => const RuleBuilderScreen(),
      ),
    ],
  );
});
