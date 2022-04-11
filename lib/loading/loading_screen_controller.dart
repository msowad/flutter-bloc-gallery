typedef StopLoading = void Function();
typedef UpdateLoadingScreen = void Function(String message);

class LoadingScreenController {
  final StopLoading stop;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.stop,
    required this.update,
  });
}
