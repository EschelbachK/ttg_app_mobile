import 'package:flutter/material.dart';

class TTGListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const TTGListTile({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (actions != null) ...actions!,
      ],
    );
  }
}