class AccountApi {
  Future<void> softDeleteAccount({
    required DateTime deletedAt,
    required DateTime restoreUntil,
  }) async {
    // backend call später
  }

  Future<void> restoreAccount() async {
    // backend call später
  }
}