import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'ttg_dialog_actions.dart';

Future<void> showTTGValuePicker({
  required BuildContext context,
  required String title,
  required double initial,
  required Function(double) onSubmit,
  bool allowDecimal = false,
}) async {
  int whole = initial.floor();
  int decimal = ((initial - whole) * 10).round();

  await showDialog(
    context: context,
    builder: (c) => Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.35),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.primaryRed.withOpacity(.15),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _wheel(
                          initial: whole,
                          max: 300,
                          onChanged: (v) => whole = v,
                        ),
                        if (allowDecimal) ...[
                          const SizedBox(width: 8),
                          const Text(".",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
                          const SizedBox(width: 8),
                          _wheel(
                            initial: decimal,
                            max: 10,
                            onChanged: (v) => decimal = v,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TTGDialogActions(
                  cancelText: "Abbrechen",
                  confirmText: "OK",
                  onCancel: () => Navigator.pop(c),
                  onConfirm: () {
                    final value = allowDecimal
                        ? whole + decimal / 10
                        : whole.toDouble();
                    onSubmit(value);
                    Navigator.pop(c);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _wheel({
  required int initial,
  required int max,
  required Function(int) onChanged,
}) {
  return StatefulBuilder(
    builder: (context, setLocal) {
      int selected = initial;

      return SizedBox(
        width: 80,
        height: 120,
        child: ListWheelScrollView.useDelegate(
          controller: FixedExtentScrollController(initialItem: initial),
          itemExtent: 40,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (i) {
            selected = i;
            setLocal(() {});
            onChanged(i);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (_, i) => Center(
              child: Text(
                "$i",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  i == selected ? FontWeight.w600 : FontWeight.normal,
                  color: i == selected
                      ? Colors.white
                      : Colors.white.withOpacity(.4),
                ),
              ),
            ),
            childCount: max,
          ),
        ),
      );
    },
  );
}