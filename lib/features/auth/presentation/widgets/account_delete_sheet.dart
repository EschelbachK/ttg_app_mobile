import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ttg_sheet.dart';

void showDeleteAccountSheetNew(BuildContext context) {
  bool confirmed = false;
  bool passwordOk = false;
  bool deleteTyped = false;
  bool locked = false;

  int countdown = 5;
  final password = TextEditingController();
  final deleteCtrl = TextEditingController();

  late Timer timer;

  showTTGBottomSheet(
    context: context,
    child: StatefulBuilder(
      builder: (context, setState) {
        passwordOk = password.text.length >= 4;
        deleteTyped = deleteCtrl.text.trim() == "DELETE";

        final ready = confirmed && passwordOk && deleteTyped && !locked;

        void startLock() {
          setState(() => locked = true);
          countdown = 5;

          timer = Timer.periodic(const Duration(seconds: 1), (t) {
            if (countdown == 0) {
              t.cancel();
              Navigator.pop(context);
            } else {
              setState(() => countdown--);
            }
          });
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Account löschen',
                style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 10),

            const Text(
              'Dein Account wird für 30 Tage deaktiviert und kann in dieser Zeit wiederhergestellt werden.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () => setState(() => confirmed = !confirmed),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: confirmed
                      ? Colors.red.withOpacity(0.15)
                      : Colors.white.withOpacity(0.06),
                  border: Border.all(
                    color: confirmed ? Colors.red : Colors.white24,
                  ),
                ),
                child: const Text('Ich verstehe die Konsequenz'),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: password,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Passwort',
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: deleteCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'DELETE eingeben',
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            GestureDetector(
              onTap: ready ? startLock : null,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: ready ? AppTheme.primaryButtonGradient : null,
                  color: ready ? null : Colors.white10,
                ),
                child: Center(
                  child: locked
                      ? Text('Deleting in $countdown...')
                      : const Text('ACCOUNT LÖSCHEN'),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}