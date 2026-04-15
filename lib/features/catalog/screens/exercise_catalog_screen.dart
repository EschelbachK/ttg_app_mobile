import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../state/exercise_catalog_provider.dart';

class ExerciseCatalogScreen extends ConsumerWidget {
  const ExerciseCatalogScreen({super.key});

  static const _baseUrl = "http://10.0.2.2:8080";

  String _img(String path) => path.isEmpty ? "" : "$_baseUrl$path";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final async = ref.watch(exerciseCatalogProvider);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/dashboard_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(.6)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Übungen",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: async.when(
            data: (items) {
              final sorted = [...items]
                ..sort((a, b) =>
                    a.name.toLowerCase().compareTo(b.name.toLowerCase()));

              return sorted.isEmpty
                  ? const Center(
                child: Text(
                  "Keine Übungen",
                  style: TextStyle(color: Colors.white54),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: sorted.length,
                itemBuilder: (_, i) {
                  final e = sorted[i];
                  final img = _img(e.imageUrl);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TTGGlowBorder(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.05),
                              borderRadius:
                              BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white
                                    .withOpacity(.08),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  child: img.isNotEmpty
                                      ? Image.network(
                                    img,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.black,
                                    child: const Icon(
                                      Icons
                                          .fitness_center,
                                      color: AppTheme
                                          .primaryRed,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        e.name,
                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.white,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${e.bodyRegion} • ${e.equipment}",
                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white38,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                e.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}