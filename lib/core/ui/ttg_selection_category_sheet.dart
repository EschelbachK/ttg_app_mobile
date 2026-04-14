import 'dart:ui';
import 'package:flutter/material.dart';

class TTGSelectionSheet<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) title;
  final String Function(T)? subtitle;
  final IconData Function(T)? icon;
  final void Function(T) onSelect;

  const TTGSelectionSheet({
    super.key,
    required this.items,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onSelect,
  });

  @override
  State<TTGSelectionSheet<T>> createState() => _TTGSelectionSheetState<T>();
}

class _TTGSelectionSheetState<T> extends State<TTGSelectionSheet<T>> {
  static const Color ttgRed = Color(0xFFE53935);

  late final ScrollController scrollController;
  bool isAtBottom = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    scrollController.addListener(() {
      final max = scrollController.position.maxScrollExtent;
      final offset = scrollController.offset;
      final atBottom = offset >= max - 10;

      if (atBottom != isAtBottom) {
        setState(() {
          isAtBottom = atBottom;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scroll() {
    if (isAtBottom) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.animateTo(
        scrollController.offset + 250,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const itemHeight = 64.0;
    const visibleItems = 6;
    final sheetHeight = (itemHeight * visibleItems) + 60;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Stack(
        children: [
          Container(color: Colors.transparent),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: sheetHeight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.12),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 8),
                                width: 42,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  controller: scrollController,
                                  physics:
                                  const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  itemCount: widget.items.length,
                                  separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                                  itemBuilder: (_, i) {
                                    final item = widget.items[i];

                                    return GestureDetector(
                                      onTap: () =>
                                          widget.onSelect(item),
                                      child: Container(
                                        height: itemHeight,
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(18),
                                          color: Colors.white
                                              .withOpacity(0.04),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: ttgRed
                                                    .withOpacity(0.15),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(14),
                                              ),
                                              child: Icon(
                                                widget.icon != null
                                                    ? widget.icon!(
                                                    item)
                                                    : Icons
                                                    .fitness_center,
                                                color: ttgRed,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Text(
                                                widget.title(item),
                                                style:
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration:
                                              BoxDecoration(
                                                color: Colors.white24,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 12,
                            bottom: 24,
                            child: GestureDetector(
                              onTap: _scroll,
                              child: AnimatedSwitcher(
                                duration: const Duration(
                                    milliseconds: 200),
                                child: Container(
                                  key: ValueKey(isAtBottom),
                                  width: 36,
                                  height: 36,
                                  decoration:
                                  const BoxDecoration(
                                    color: ttgRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isAtBottom
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}