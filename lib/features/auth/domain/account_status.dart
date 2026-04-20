class AccountStatus {
  final bool isActive;
  final DateTime? deletedAt;
  final DateTime? restoreUntil;

  const AccountStatus({
    required this.isActive,
    this.deletedAt,
    this.restoreUntil,
  });

  bool get isInRecoveryWindow {
    if (deletedAt == null) return false;
    return DateTime.now().isBefore(
      deletedAt!.add(const Duration(days: 30)),
    );
  }
}