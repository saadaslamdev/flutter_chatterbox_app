import 'package:flutter/material.dart';

typedef FunctionOperation<T> = Future<T> Function();
typedef FunctionOnComplete = void Function(BuildContext context);
typedef FunctionOnError = void Function(BuildContext context, Object? error);

class FutureFullscreenLoader<T> {
  static void show<T>({
    required BuildContext context,
    required FunctionOperation<T> future,
    required FunctionOnComplete onComplete,
    required FunctionOnError onError,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _FutureFullscreenLoaderDialog<T>(
          future: future,
          onComplete: onComplete,
          onError: onError,
        );
      },
    );
  }
}

class _FutureFullscreenLoaderDialog<T> extends StatefulWidget {
  final FunctionOperation<T> future;
  final FunctionOnComplete onComplete;
  final FunctionOnError onError;

  const _FutureFullscreenLoaderDialog({
    required this.future,
    required this.onComplete,
    required this.onError,
  });

  @override
  State<_FutureFullscreenLoaderDialog<T>> createState() =>
      _FutureFullscreenLoaderDialogState<T>();
}

class _FutureFullscreenLoaderDialogState<T>
    extends State<_FutureFullscreenLoaderDialog<T>> {
  late Future<T> operation;

  @override
  void initState() {
    super.initState();
    operation = widget.future();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.transparent,
            child: FutureBuilder<T>(
              future: operation,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  var error = snapshot.error;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (error != null) {
                      widget.onError(context, error);
                    }
                    Navigator.of(context).pop();
                  });
                }

                if (!snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onComplete(context);
                    Navigator.of(context).pop();
                  });
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ],
    );
  }
}
