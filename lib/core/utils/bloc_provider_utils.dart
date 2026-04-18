import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

T? maybeReadBloc<T extends StateStreamableSource<Object?>>(
  BuildContext context,
) {
  try {
    return BlocProvider.of<T>(context);
  } catch (_) {
    return null;
  }
}
