import 'package:flutter/material.dart';

class VolumeChart extends StatelessWidget {
  final List<double> volumes;

  const VolumeChart({super.key, required this.volumes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: volumes.map((v) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: v,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}