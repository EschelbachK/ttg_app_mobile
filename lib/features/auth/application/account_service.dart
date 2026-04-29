import '../../../core/api/auth_account_api.dart.dart';

class AccountService {
  final AccountApi api;

  AccountService(this.api);

  Future<void> softDelete() async {
    final now = DateTime.now();

    await api.softDeleteAccount(
      deletedAt: now,
      restoreUntil: now.add(const Duration(days: 30)),
    );
  }

  Future<void> restore() async {
    await api.restoreAccount();
  }
}