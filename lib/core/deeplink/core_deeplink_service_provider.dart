import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';

final deepLinkProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService();
  ref.onDispose(service.dispose);
  return service;
});

class DeepLinkService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  void init(Function(Uri uri) onLink) async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        onLink(initial);
      }
    } catch (_) {}

    _sub = _appLinks.uriLinkStream.listen(
          (uri) {
        onLink(uri);
      },
      onError: (_) {},
    );
  }

  void dispose() {
    _sub?.cancel();
  }
}