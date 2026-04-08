class UiState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  const UiState._({
    required this.isLoading,
    this.data,
    this.error,
  });

  const UiState.initial() : this._(isLoading: false);

  const UiState.loading() : this._(isLoading: true);

  const UiState.success(T data) : this._(isLoading: false, data: data);

  const UiState.error(String message)
      : this._(isLoading: false, error: message);
}