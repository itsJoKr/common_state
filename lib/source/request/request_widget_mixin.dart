import 'package:common_state/common_state.dart';
import 'package:common_state/source/state/request_bloc_state.dart';
import 'package:flutter/material.dart';

import '../request_snapshot.dart';

abstract class RequestWidgetMixin<E> {
  Widget getErrorWidgetWithButton(
      BuildContext context,
      ErrorRequestWidgetBuilder<E> buildError,
      ErrorState<E> state,
      VoidCallback onRetry,
      VoidCallback onPressed
      ) {
    return Column(children: <Widget>[
      getErrorWidget(context, buildError, state, onRetry),
      // todo: somehow pass this widget build onto client
      SizedBox(height: 16,),
      FlatButton(child: Text("OK"), onPressed: onPressed,)
    ],);
  }

  Widget getErrorWidget(
      BuildContext context,
      ErrorRequestWidgetBuilder<E> buildError,
      ErrorState<E> state,
      VoidCallback onRetry) {
    if (buildError == null) {
      return CommonStateHandling().errorBuilder(
          context,
          state,
          onRetry != null,
          onRetry
      );
    } else {
      final w = buildError(context, state);
      return w ?? CommonStateHandling().errorBuilder(
              context,
              state,
              onRetry != null,
              onRetry
          );
    }
  }
}
