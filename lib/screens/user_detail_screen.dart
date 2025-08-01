/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../constants/app_colors.dart';

class UserDetailScreen extends StatelessWidget {
  static const routeName = '/user_detail';
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(.10),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(.05),
              AppColors.accent.withOpacity(.25),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, kToolbarHeight + 96, 24, 32),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(.35)),
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: 'avatar_${user.id}',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.primary.withOpacity(.20),
                        backgroundImage: CachedNetworkImageProvider(user.avatar),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(user.fullName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(user.email,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 32),
                    _infoRow('User ID', '#${user.id}'),
                    const Divider(color: Colors.white24),
                    _infoRow('First Name', user.firstName),
                    const Divider(color: Colors.white24),
                    _infoRow('Last Name', user.lastName),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
            const TextStyle(color: Colors.white70, fontSize: 15)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}
*/
// ignore_for_file: avoid_unnecessary_containers

/*───────────────────────────────────────────────────────────────────────────
  User‑Detail Screen – professional blue theme (matches list & splash)
  Design reference: curved header with avatar, minimal info rows
────────────────────────────────────────────────────────────────────────────*/

// lib/screens/user_detail_screen.dart
// ignore_for_file: avoid_unnecessary_containers

/*───────────────────────────────────────────────────────────────────────────
  User‑Detail Screen – dark variant exactly like reference image 🔥
  ---------------------------------------------------------------------------
  • Sky‑blur cover (with small chevron icon) at top of phone frame
  • Dark navy sheet with large rounded top‑corners slides up under cover
  • Avatar overlaps both layers; yellow floating edit badge
  • Name + role (email) inside header
  • Navigation menu list items (icons + text) in the navy sheet
  • All interactions preserved – on back press pops
────────────────────────────────────────────────────────────────────────────*/

// lib/screens/user_detail_screen.dart
// ignore_for_file: prefer_const_constructors

/*───────────────────────────────────────────────────────────────────────────
  User‑Detail Screen – polished minimal v2  + micro‑animations
  ---------------------------------------------------------------------------
  ● Brand gradient backdrop (navy → lavender).
  ● White profile card & info list animate softly on load:
      • Card: scale‑in from 0.9 → 1.0 (Curve.easeOutBack)
      • Info list: fade‑in & slide‑up (Offset(0, 0.1) → Offset.zero)
  ● No edit icon (per user), translucent back control.
────────────────────────────────────────────────────────────────────────────*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/user_model.dart';

class UserDetailScreen extends StatefulWidget {
  static const routeName = '/user_detail';
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _cardCtrl;
  late final AnimationController _listCtrl;

  @override
  void initState() {
    super.initState();
    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _listCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // staggered start
    _cardCtrl.forward();
    Future.delayed(const Duration(milliseconds: 150), _listCtrl.forward);
  }

  @override
  void dispose() {
    _cardCtrl.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    const double avatarR = 46;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // gradient backdrop
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.accent],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // profile card with scale animation
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _cardCtrl,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'avatar_${user.id}',
                              child: CircleAvatar(
                                radius: avatarR,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                CachedNetworkImageProvider(user.avatar),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // info list fade/slide animation
                  FadeTransition(
                    opacity: _listCtrl,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _listCtrl,
                        curve: Curves.easeOut,
                      )),
                      child: Material(
                        elevation: 3,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            _tile('User ID', '#${user.id}'),
                            _tile('First Name', user.firstName),
                            _tile('Last Name', user.lastName),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // translucent back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(String title, String value) => ListTile(
    dense: true,
    title: Text(title, style: TextStyle(color: Colors.black54)),
    trailing: Text(value,
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600)),
  );
}
