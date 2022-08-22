import 'package:flutter/material.dart';

enum AppLoaderType { fullscreen, overlay }

class AppLoader {
  bool _isShowing = false;

  show(
    BuildContext context, {
    AppLoaderType type = AppLoaderType.overlay,
    String? message,
    Key? key,
    bool isDismissible = false,
    bool createNew = true,
  }) {
    if (!createNew && _isShowing) {
      return;
    }
    hide(context);
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (_) {
        return WillPopScope(
            onWillPop: () => Future.value(isDismissible),
            child: AppOverlayLoader(
              key: key,
            ));
      },
    );
  }

  hide(BuildContext context, {String? message, Key? key}) {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(context).pop();
    }
  }
}

class AppOverlayLoader extends StatelessWidget {
  final Widget? widget;

  final double? loaderWidth, loaderHeight;

  const AppOverlayLoader(
      {Key? key, this.widget, this.loaderHeight, this.loaderWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: widget ??
          SizedBox(
            //color: Colors.transparent.withOpacity(0.5),
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: loaderHeight ?? 35.0,
                    width: loaderWidth ?? 35.0,
                    key: key,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }
}
