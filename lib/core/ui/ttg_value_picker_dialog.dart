import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

Future<void> showTTGValuePicker({
  required BuildContext context,
  required String title,
  required double initial,
  required Function(double) onSubmit,
  bool allowDecimal = false,
}) async {
  int whole = initial.floor();
  int decimal = ((initial - whole) * 10).round();

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    isScrollControlled: true,
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 0.40, // 🔥 kompakte Premium Höhe
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Stack(
            children: [
              Container(color: Colors.transparent),

              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.42),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.10),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            /// HANDLE
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            /// 🔥 TITLE (tiefer + cleaner)
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 20,
                                    height: 2,
                                    color: AppTheme.primaryRed),
                                const SizedBox(width: 8),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                    width: 20,
                                    height: 2,
                                    color: AppTheme.primaryRed),
                              ],
                            ),

                            /// 🔥 TTG GLOW LINE
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.primaryRed.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            /// 🔥 WHEEL AREA
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  height: 90,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      /// GLASS FOCUS BAR
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.06),
                                              borderRadius:
                                              BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.08),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// WHEELS
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          TTGWheel(
                                            initial: whole,
                                            max: 300,
                                            onChanged: (v) => whole = v,
                                          ),
                                          if (allowDecimal) ...[
                                            const SizedBox(width: 6),
                                            const Text(".",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            const SizedBox(width: 6),
                                            TTGWheel(
                                              initial: decimal,
                                              max: 10,
                                              onChanged: (v) => decimal = v,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// BUTTONS
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      height: 42,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(14),
                                        color: Colors.white
                                            .withOpacity(0.06),
                                      ),
                                      child: const Text(
                                        "Abbrechen",
                                        style: TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      final value = allowDecimal
                                          ? whole + decimal / 10
                                          : whole.toDouble();
                                      onSubmit(value);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 42,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(14),
                                        color: AppTheme.primaryRed,
                                      ),
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class TTGWheel extends StatefulWidget {
  final int initial;
  final int max;
  final Function(int) onChanged;

  const TTGWheel({
    super.key,
    required this.initial,
    required this.max,
    required this.onChanged,
  });

  @override
  State<TTGWheel> createState() => _TTGWheelState();
}

class _TTGWheelState extends State<TTGWheel> {
  late int selected;
  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;

    controller = FixedExtentScrollController(
      initialItem: widget.initial,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 36,
        physics: const FixedExtentScrollPhysics(),

        /// 🔥 KEY FIX
        onSelectedItemChanged: (i) {
          setState(() {
            selected = i;
          });
          widget.onChanged(i);
        },

        childDelegate: ListWheelChildBuilderDelegate(
          builder: (_, i) {
            final isSelected = i == selected;

            return Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 80),
                style: TextStyle(
                  fontSize: isSelected ? 22 : 16,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.25),
                ),
                child: Text("$i"),
              ),
            );
          },
          childCount: widget.max,
        ),
      ),
    );
  }
}