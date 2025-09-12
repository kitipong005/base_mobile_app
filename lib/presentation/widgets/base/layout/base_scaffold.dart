import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/design_system/colors.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.endDrawer,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.systemOverlayStyle,
    this.padding,
    this.safeArea = true,
    this.showAppBar = true,
    this.title,
    this.titleWidget,
    this.centerTitle,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.titleSpacing,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.isLoading = false,
    this.loadingWidget,
  });

  // Scaffold properties
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final Widget? endDrawer;
  final DrawerCallback? onDrawerChanged;
  final DrawerCallback? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final SystemUiOverlayStyle? systemOverlayStyle;
  
  // Additional properties
  final EdgeInsetsGeometry? padding;
  final bool safeArea;
  
  // AppBar properties
  final bool showAppBar;
  final String? title;
  final Widget? titleWidget;
  final bool? centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final double? toolbarHeight;
  final double? leadingWidth;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? titleSpacing;
  final double? scrolledUnderElevation;
  final ScrollNotificationPredicate notificationPredicate;

  // Loading state
  final bool isLoading;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      drawer: drawer,
      endDrawer: endDrawer,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (!showAppBar && appBar == null) return null;

    if (appBar != null) {
      return _wrapWithSystemOverlay(appBar!);
    }

    return _wrapWithSystemOverlay(
      AppBar(
        title: titleWidget ?? (title != null ? Text(title!) : null),
        centerTitle: centerTitle,
        leading: leading,
        actions: actions,
        automaticallyImplyLeading: automaticallyImplyLeading,
        elevation: elevation ?? 1,
        shadowColor: shadowColor ?? Theme.of(context).shadowColor,
        surfaceTintColor: surfaceTintColor ?? Colors.transparent,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        toolbarTextStyle: toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        toolbarHeight: toolbarHeight,
        leadingWidth: leadingWidth,
        toolbarOpacity: toolbarOpacity,
        bottomOpacity: bottomOpacity,
        titleSpacing: titleSpacing,
        scrolledUnderElevation: scrolledUnderElevation,
        notificationPredicate: notificationPredicate,
        systemOverlayStyle: systemOverlayStyle,
      ),
    );
  }

  PreferredSizeWidget _wrapWithSystemOverlay(PreferredSizeWidget appBar) {
    if (systemOverlayStyle == null) return appBar;

    return PreferredSize(
      preferredSize: appBar.preferredSize,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemOverlayStyle!,
        child: appBar,
      ),
    );
  }

  Widget? _buildBody(BuildContext context) {
    Widget? bodyWidget = body;

    if (bodyWidget == null && !isLoading) return null;

    if (isLoading) {
      bodyWidget = Stack(
        children: [
          if (body != null) body!,
          Container(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            child: Center(
              child: loadingWidget ??
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      );
    }

    if (padding != null) {
      bodyWidget = Padding(
        padding: padding!,
        child: bodyWidget,
      );
    }

    if (safeArea) {
      bodyWidget = SafeArea(
        child: bodyWidget!,
      );
    }

    return bodyWidget;
  }
}

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.titleSpacing,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.systemOverlayStyle,
    this.showBackButton = true,
    this.onBackPressed,
  });

  final String? title;
  final Widget? titleWidget;
  final bool? centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final double? toolbarHeight;
  final double? leadingWidth;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? titleSpacing;
  final double? scrolledUnderElevation;
  final ScrollNotificationPredicate notificationPredicate;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      centerTitle: centerTitle,
      leading: _buildLeading(context),
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading && leading == null,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      backgroundColor: backgroundColor ?? AppColors.surface,
      foregroundColor: foregroundColor ?? AppColors.onSurface,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      titleSpacing: titleSpacing,
      scrolledUnderElevation: scrolledUnderElevation,
      notificationPredicate: notificationPredicate,
      systemOverlayStyle: systemOverlayStyle,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}

extension BaseScaffoldFactory on BaseScaffold {
  static Widget simple({
    Key? key,
    String? title,
    Widget? titleWidget,
    Widget? body,
    List<Widget>? actions,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    bool safeArea = true,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    bool isLoading = false,
    Widget? loadingWidget,
  }) {
    return BaseScaffold(
      key: key,
      title: title,
      titleWidget: titleWidget,
      body: body,
      actions: actions,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      safeArea: safeArea,
      padding: padding,
      backgroundColor: backgroundColor,
      isLoading: isLoading,
      loadingWidget: loadingWidget,
    );
  }

  static Widget withoutAppBar({
    Key? key,
    Widget? body,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    bool safeArea = true,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    bool isLoading = false,
    Widget? loadingWidget,
  }) {
    return BaseScaffold(
      key: key,
      showAppBar: false,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      safeArea: safeArea,
      padding: padding,
      backgroundColor: backgroundColor,
      isLoading: isLoading,
      loadingWidget: loadingWidget,
    );
  }
}