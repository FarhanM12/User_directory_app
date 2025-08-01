// lib/widgets/user_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class UserCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String email;
  final VoidCallback onTap;

  const UserCard({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.email,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double avatarR = 30;
    const double headerH = 80;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // coloured header with concave bottom
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: _ConcaveClipper(depth: 26),
                  child: Container(
                    height: headerH,
                    decoration: BoxDecoration(
                      color: AppColors.accent, // lavender‑ish (adjust in palette)
                    ),
                  ),
                ),
                // avatar overlapping header / body
                Positioned(
                  top: headerH - avatarR - 6,
                  left: 20,
                  child: CircleAvatar(
                    radius: avatarR,
                    backgroundColor: Colors.white,
                    backgroundImage: CachedNetworkImageProvider(avatarUrl),
                  ),
                ),
                // yellow edit badge (decorative)
                Positioned(
                  top: headerH + 2,
                  left: 20 + 2 * avatarR - 10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7D139),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 12, color: Colors.black87),
                  ),
                ),
                // name + email centred in header
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name,
                            style: AppTextStyles.textTheme.titleMedium!
                                .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(email,
                            style: AppTextStyles.textTheme.bodySmall!
                                .copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: headerH / 2), // space under header curve
          ],
        ),
      ),
    );
  }
}

/*──────────────────────── concave bottom clipper ─────────────────────────*/
class _ConcaveClipper extends CustomClipper<Path> {
  final double depth;
  _ConcaveClipper({this.depth = 24});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - depth);
    path.quadraticBezierTo(size.width / 2, size.height + depth, size.width,
        size.height - depth);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
