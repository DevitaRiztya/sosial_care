import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/notification_model.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/empty_state_card.dart';

class NotifikasiScreen extends StatelessWidget {
  final BantuAksesRepository repository;

  const NotifikasiScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final notifications = repository.notifications;
        final unreadCount = repository.unreadNotificationsCount;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: BantuAppBar(
            title: 'Pemberitahuan Resmi',
            subtitle: unreadCount > 0 ? '$unreadCount pesan belum dibaca' : 'Semua pesan sudah dibaca',
            showBackButton: true,
            actions: [
              if (unreadCount > 0)
                TextButton(
                  onPressed: () => repository.markAllNotificationsAsRead(),
                  child: const Text(
                    'Tandai Dibaca',
                    style: TextStyle(color: AppColors.warmCreamDark, fontSize: 12),
                  ),
                ),
            ],
          ),
          body: notifications.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: EmptyStateCard(
                      icon: Icons.notifications_off_outlined,
                      title: 'Belum Ada Pemberitahuan',
                      message: 'Seluruh informasi perkembangan bantuan sosial akan ditampilkan di sini.',
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return _buildNotificationCard(context, notif);
                  },
                ),
        );
      },
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationModel notif) {
    Color catBg;
    Color catColor;

    switch (notif.category) {
      case 'Status Pengajuan':
        catBg = AppColors.statusInfoBg;
        catColor = AppColors.statusInfo;
        break;
      case 'Penyaluran':
        catBg = AppColors.statusSuccessBg;
        catColor = AppColors.statusSuccess;
        break;
      default:
        catBg = AppColors.forestGreenSurface;
        catColor = AppColors.forestGreenDark;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: notif.isRead ? AppColors.surfaceWhite : AppColors.warmCreamLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notif.isRead ? AppColors.borderLight : AppColors.borderMedium,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            if (!notif.isRead) {
              repository.markNotificationAsRead(notif.id);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: catBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        notif.category,
                        style: AppTypography.labelSmall.copyWith(
                          color: catColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      notif.date,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    if (!notif.isRead) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.forestGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notif.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notif.message,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (notif.relatedCode != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.tag_rounded, size: 14, color: AppColors.forestGreen),
                      const SizedBox(width: 4),
                      Text(
                        'Terkait: ${notif.relatedCode}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
