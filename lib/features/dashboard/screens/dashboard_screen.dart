import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/dashboard_provider.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/dashboard_toggle.dart';
import '../widgets/dashboard_bottom_bar.dart';
import '../widgets/folder_card.dart';
import '../widgets/dashboard_drawer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const DashboardTopBar(),
      drawer: const DashboardDrawer(),
      bottomNavigationBar: const DashboardBottomBar(),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: DashboardToggle()),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Text(
                  'MEINE TRAININGSPLÄNE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, i) => FolderCard(folder: folders[i]),
                  childCount: folders.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
      ),
    );
  }
}