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
  });

  bool get isSwitch => value != null && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (expandable) {
          onTap?.call();
        } else if (isSwitch) {
          onChanged?.call(!value!);
        } else {
          onTap?.call();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: isSwitch && value == true
                      ? t.colorScheme.primary.withOpacity(0.5)
                      : Colors.white.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
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
                      color: Colors.white.withOpacity(0.04),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: isSwitch && value == true
                          ? t.colorScheme.primary
                          : t.iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: t.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              subtitle!,
                              style: t.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (isSwitch)
                    GestureDetector(
                      onTap: () => onChanged!(!value!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 26,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: value!
                              ? t.colorScheme.primary
                              : Colors.white.withOpacity(0.15),
                        ),
                        child: Align(
                          alignment: value!
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
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
                    ),

                  if (expandable)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}