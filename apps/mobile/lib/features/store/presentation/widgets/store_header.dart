import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';

class StoreHeader extends StatefulWidget {
  final bool isOpen;
  final ValueChanged<bool> onToggleOpen;
  final bool isRushMode;
  final ValueChanged<bool> onToggleRush;
  final bool soundEnabled;
  final VoidCallback onToggleSound;

  const StoreHeader({
    super.key,
    required this.isOpen,
    required this.onToggleOpen,
    required this.isRushMode,
    required this.onToggleRush,
    required this.soundEnabled,
    required this.onToggleSound,
  });

  @override
  State<StoreHeader> createState() => _StoreHeaderState();
}

class _StoreHeaderState extends State<StoreHeader> {
  late String _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    setState(() {
      _currentTime = '$hour:$minute $ampm';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.hairline, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Brand & Store (Original Grocerra Brand Wordmark)
          Expanded(
            child: Row(
              children: [
                // Authentic Grocerra Brand SVG Wordmark
                SvgPicture.asset(
                  'assets/brand/wordmark_light.svg',
                  height: 22,
                ),
                const SizedBox(width: 10),
                Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF86EFAC),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'STORE MANAGER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF166534),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  height: 24,
                  width: 1,
                  color: AppColors.hairline,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 16,
                        color: AppColors.inkMuted,
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Madina Halal Meats & Groceries · Coburg VIC',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Center: Open/Closed & Rush Mode
          Row(
            children: [
              // Store Status Card (38px height, 8px radius, white background, ShadSwitch)
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.hairline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.isOpen
                            ? AppColors.accent
                            : AppColors.inkMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isOpen ? 'Open for Orders' : 'Store Paused',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ShadSwitch(
                      value: widget.isOpen,
                      onChanged: widget.onToggleOpen,
                      checkedTrackColor: AppColors.accent,
                      width: 34,
                      height: 18,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Rush Mode Toggle Card (38px height, 8px radius, same geometry)
              InkWell(
                onTap: () => widget.onToggleRush(!widget.isRushMode),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: widget.isRushMode
                        ? const Color(0xFFFFFBEB)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.isRushMode
                          ? const Color(0xFFD97706)
                          : AppColors.hairline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: widget.isRushMode
                            ? const Color(0xFFD97706)
                            : Colors.amber.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.isRushMode ? 'Rush Mode (+10m)' : 'Rush Mode Off',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: widget.isRushMode
                              ? const Color(0xFFD97706)
                              : AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 10),

          // Right: Sound Alerts & Clock (all 38px height, 8px radius)
          Row(
            children: [
              // Chime Sound Card
              InkWell(
                onTap: widget.onToggleSound,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.hairline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.soundEnabled
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                        size: 16,
                        color: widget.soundEnabled
                            ? AppColors.accent
                            : AppColors.danger,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.soundEnabled ? 'Chime On' : 'Muted',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: widget.soundEnabled
                              ? AppColors.ink
                              : AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Live Time Card
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.hairline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 15,
                      color: AppColors.inkMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _currentTime,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
