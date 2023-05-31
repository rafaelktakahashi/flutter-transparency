import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ModalTemplateMode { centered, bottomCard }

/// Template for a page that renders in a modal.
/// Whatever page uses this template must be rendered in a transparent route.
class ModalTemplate extends StatelessWidget {
  final String title;
  final Widget child;
  final ModalTemplateMode mode;

  const ModalTemplate({
    super.key,
    required this.title,
    required this.child,
    this.mode = ModalTemplateMode.centered,
  });

  void back(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // Animated is for iOS only.
      SystemNavigator.pop(animated: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This gesture detector covers the entire screen, and lets the user
    // dismiss the modal by touching outside of it.
    return GestureDetector(
      onTap: () {
        back(context);
      },
      // It seems I need a container with non-null color to make the gesture
      // work, but I don't know why. Maybe colorless containers let touches fall
      // through?
      child: Container(
        // If you need to dim the background, this is not the place for it.
        // Using a color here creates a sharp edge that may be fine if you're
        // using a fade in/out transition, but is very visible when sliding.
        // If this needs to render on top of a Flutter screen, you can add that
        // logic in a custom transition; if it needs to render over a native
        // screen, it's harder to know _how_ this modal will appear on screen,
        // so it's safer to handle that natively too.
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        // Don't let the modal overlap with the status bar.
        child: CustomConstrainingBox(
          mode: mode,
          child: GestureDetector(
            onTap: () {},
            // Round the modal's corners.
            child: ClipRRect(
              // When centered, round all corners; when rendering at the
              // bottom, round only the top corners.
              borderRadius: mode == ModalTemplateMode.bottomCard
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                  : BorderRadius.circular(15),
              // This is a blurred container. It doesn't really have to
              // do with app functionality, it's just here to show that
              // this screen can be transparent if needed.
              child: TransparentContainer(
                // Override the child's scaffold color, because the
                // blurred container already applies the tint.
                child: Theme(
                  data: Theme.of(context).copyWith(
                    scaffoldBackgroundColor: Colors.transparent,
                  ),
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(title),
                      // Show a close button when it's a modal, and nothing
                      // when it's a card. Of course, you can also make this
                      // configurable.
                      actions: mode == ModalTemplateMode.centered
                          ? <Widget>[
                              IconButton(
                                onPressed: () {
                                  back(context);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ]
                          : null,
                    ),
                    // In the case of rendering the content at the bottom of the
                    // page, this ensures that the card's content doesn't render
                    // behind the navigation bar. If rendering the card at the
                    // centering this has no effect anyway.
                    body: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// When the mode is centered, returns a centered box of fixed size. When the
/// mode is bottomCard, returns a card at the bottom of the screen that occupies
/// 40% of the total screen height.
class CustomConstrainingBox extends StatelessWidget {
  final ModalTemplateMode mode;
  final Widget child;

  const CustomConstrainingBox({
    super.key,
    required this.mode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case ModalTemplateMode.centered:
        // Safe area outside of the content, to ensure that the modal won't
        // render behind the status bar or the navigation bar.
        return SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 600,
                maxWidth: 600,
              ),
              // Limit the modal's size to ensure that it always shows a bit of
              // the previous page around the edges.
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: child,
              ),
            ),
          ),
        );
      case ModalTemplateMode.bottomCard:
        // Do not avoid bottom intrusions with the safe area, because the card
        // needs to render behind the navigation bar.
        // If I omit the SafeArea or use a SafeArea inside the Scaffold, the
        // appbar renders too tall for some reason.
        return SafeArea(
          bottom: false,
          child: FractionallySizedBox(
            alignment: FractionalOffset.bottomCenter,
            widthFactor: 1,
            heightFactor: 0.4,
            child: child,
          ),
        );
    }
  }
}

class TransparentContainer extends StatelessWidget {
  const TransparentContainer({
    Key? key,
    required this.child,
    this.minHeight = 0,
    this.minWidth = 0,
    this.borderWidth = 0,
    this.borderRadius = 0,
    this.onTap,
  }) : super(key: key);

  // When using minHeight, provide minWidth as well.
  final double minHeight;

  // When using minWidth, provide minHeight as well.
  final double minWidth;
  final VoidCallback? onTap;
  final double borderWidth;
  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      constraints: minWidth != 0
          ? BoxConstraints(
              minHeight: minHeight,
              minWidth: minWidth,
            )
          : null,
      decoration: BoxDecoration(
        border: borderWidth > 0
            ? Border.all(
                color: Theme.of(context).colorScheme.background.withAlpha(0xff),
                width: borderWidth,
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        // Use an opaque color when a gradient is provided.
        color: Theme.of(context).colorScheme.background.withAlpha(0xff),
      ),
      child: child,
    );

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        // This will blur anything behind this rectangle. Always test if things
        // are actually blurred; some components (e.g. maps) may not be affected
        // by blurred widgets in front of them.
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: container,
        ),
      ),
    );
  }
}
