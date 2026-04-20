import 'dart:convert';

class OfflineAction {
  final String type;
  final Map<String, dynamic> payload;

  const OfflineAction({
    required this.type,
    required this.payload,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'payload': payload,
  };

  factory OfflineAction.fromJson(Map<String, dynamic> json) {
    return OfflineAction(
      type: json['type'],
      payload: Map<String, dynamic>.from(json['payload']),
    );
  }

  static String encode(List<OfflineAction> actions) =>
      jsonEncode(actions.map((e) => e.toJson()).toList());

  static List<OfflineAction> decode(String raw) {
    final list = jsonDecode(raw) as List;
    return list.map((e) => OfflineAction.fromJson(e)).toList();
  }
}