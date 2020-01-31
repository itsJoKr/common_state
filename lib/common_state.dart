library common_state;

import 'package:common_state/source/state/bloc_state.dart';
import 'package:common_state/source/state/request_bloc_state.dart';
import 'package:flutter/cupertino.dart';

export 'package:common_state/common_state.dart';

export './source/state/bloc_state.dart';
export './source/state/request_bloc_state.dart';
export './source/event/bloc_event.dart';
export './source/event/request_event.dart';
export './source/request/blocking_request.dart';
export './source/request/in_layout_request.dart';
export './source/bloc/request_bloc.dart';

typedef ErrorWidgetBuilder = Function(BuildContext context, ErrorState error, bool showRetry, VoidCallback onRetry);
typedef BlockingDialogBuilder = Function(BuildContext context, Widget child, BlocState state);

class CommonStateHandling {
  static final CommonStateHandling _singleton = CommonStateHandling._internal();

  // todo: we can maybe package-private this
  ErrorWidgetBuilder errorBuilder;
  WidgetBuilder loadingBuilder;
  BlockingDialogBuilder dialogBuilder;

  factory CommonStateHandling() {
    return _singleton;
  }

  CommonStateHandling._internal();

  /// Register the widget that will be built and show in case of the error
  ///
  /// Parameters provided:
  /// ErrorState error - error state that contains data that can be shown to user
  /// bool showRetry - whether you should show retry button
  /// VoidCallback onRetry - callback that should be called after clicking retry
  static registerCommonErrorWidget(ErrorWidgetBuilder builder) {
    CommonStateHandling().errorBuilder = builder;
  }

  /// Register the widget that will be built and show in case of the loading
  /// Usually some kind of progress indicator
  static registerCommonLoadingWidget(WidgetBuilder builder) {
    CommonStateHandling().loadingBuilder = builder;
  }

  /// Register the widget that will be built and show in case of blocking
  /// request. The common error and loading widgets will be provided as
  /// a [child] param and they should be included in dialog.
  static registerBlockingDialogWidget(BlockingDialogBuilder builder) {
    CommonStateHandling().dialogBuilder = builder;
  }


}