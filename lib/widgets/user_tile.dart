
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../constants/app_colors.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ListTile(
          tileColor: Colors.white.withOpacity(.08),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: Hero(
            tag: 'avatar_${user.id}',
            child: CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary.withOpacity(.20),
              backgroundImage: CachedNetworkImageProvider(user.avatar),
            ),
          ),
          title: Text(user.fullName,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white)),
          subtitle: Text(user.email,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          trailing:
          const Icon(Icons.chevron_right, color: Colors.white60, size: 20),
          onTap: () => Navigator.pushNamed(
            context,
            '/user_detail',
            arguments: user,
          ),
        ),
      ),
    );
  }
}
