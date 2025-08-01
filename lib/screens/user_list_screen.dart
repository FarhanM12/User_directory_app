
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/user_provider.dart';
import '../widgets/user_tile.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);
  static const routeName = '/list';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..loadFirst(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(.92),
                AppColors.primary.withOpacity(.75),
                AppColors.primary.withOpacity(.58),
              ],
            ),
          ),
          child: const _MainContent(),
        ),
      ),
    );
  }
}

/*───────────────────────── main scrollable content ─────────────────────────*/
class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: const [
        _MinimalAppBar(title: 'Users'),
        SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: _UserListBody(),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

/*──────────────────────────── streamlined app-bar ─────────────────────────*/
class _MinimalAppBar extends StatelessWidget {
  final String title;
  const _MinimalAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      flexibleSpace: SafeArea(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: .2,
            ),
          ),
        ),
      ),
    );
  }
}

/*──────────────────────── provider-driven list body ───────────────────────*/
class _UserListBody extends StatelessWidget {
  const _UserListBody();

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
    builder: (_, p, __) {
      if (p.loading && p.users.isEmpty) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      }
      if (p.error != null && p.users.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: TextButton.icon(
              onPressed: p.loadFirst,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      }

      return SliverList.separated(
        itemCount: p.users.length + (p.hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          if (i == p.users.length) {
            p.loadNext();
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }
          return _GlassTile(child: UserTile(user: p.users[i]));
        },
      );
    },
  );
}

/*───────────────────── subtle frosted glass tile ──────────────────────────*/
class _GlassTile extends StatelessWidget {
  final Widget child;
  const _GlassTile({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(.12), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
