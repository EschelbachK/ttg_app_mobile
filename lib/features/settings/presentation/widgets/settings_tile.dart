import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final bool expandable;
  final bool isExpanded;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.value,
    this.onChanged,
    this.expandable = false,
    this.isExpanded = false,
    this.trailing,
  });

  bool get isSwitch => value != null && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final active = isSwitch && value == true;

    final borderColor = active
        ? t.colorScheme.primary.withOpacity(0.5)
        : isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.06);

    final tileColor =
    isDark ? Colors.white.withOpacity(0.05) : Colors.white;

    final iconColor =
    active ? t.colorScheme.primary : t.iconTheme.color;

    final subtitleColor = isDark
        ? Colors.white.withOpacity(0.5)
        : Colors.black.withOpacity(0.6);

    final expandColor = isDark
        ? Colors.white.withOpacity(0.4)
        : Colors.black.withOpacity(0.4);

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: tileColor,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.6)
                : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.04),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: t.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(subtitle!, style: t.textTheme.bodySmall?.copyWith(color: subtitleColor)),
                  ),
              ],
            ),
          ),

          if (trailing != null) trailing!,

          if (isSwitch) _switch(t, isDark),

          if (expandable)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: expandColor,
              ),
            ),
        ],
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        child: isDark
            ? ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: content,
          ),
        )
            : content,
      ),
    );
  }

  Widget _switch(ThemeData t, bool isDark) {
    final active = value == true;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged?.call(!value!),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: active
              ? t.colorScheme.primary
              : isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.black.withOpacity(0.1),
        ),
        child: Align(
          alignment:
          active ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}