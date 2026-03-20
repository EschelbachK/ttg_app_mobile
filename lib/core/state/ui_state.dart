class UiState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  const UiState({
    required this.isLoading,
    this.data,
    this.error,
  });

  factory UiState.initial() => const UiState(isLoading: false);

  factory UiState.loading() => const UiState(isLoading: true);

  factory UiState.success(T data) => UiState(isLoading: false, data: data);

  factory UiState.error(String message) =>
      UiState(isLoading: false, error: message);
}