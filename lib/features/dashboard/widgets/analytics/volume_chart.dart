import 'package:flutter/material.dart';
import '../../domain/dashboard_data.dart';

class VolumeChart extends StatelessWidget {
  final List<VolumePoint> data;

  const VolumeChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(height: 200);
    }

    final maxVolume =
    data.map((e) => e.volume).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((point) {
          final normalized = maxVolume == 0 ? 0.0 : point.volume / maxVolume;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                height: 200 * normalized,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7B61FF),
                      Color(0xFF5AC8FA),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}