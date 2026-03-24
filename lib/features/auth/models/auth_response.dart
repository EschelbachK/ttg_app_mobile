class AuthResponse {
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {

    final Map<String, dynamic> data =
    json.containsKey("data")
        ? json["data"]
        : json;

    final accessToken =
        data["accessToken"] ??
            data["access_token"];

    final refreshToken =
        data["refreshToken"] ??
            data["refresh_token"];

    if (accessToken == null || refreshToken == null) {
      throw Exception("Invalid auth response format: $json");
    }

    return AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }
}