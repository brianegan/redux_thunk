import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:test/test.dart';

void main() {
  final Reducer<String> identityReducer =
      (String state, dynamic action) => action is String ? action : state;

  group('Thunk Middleware', () {
    test('dispatches an action from ThunkActions', () {
      final store = new Store<String>(
        identityReducer,
        middleware: [thunkMiddleware],
      );
      final dispatchedAction = "Friend";
      final ThunkAction<String> action = (Store<String> store) {
        store.dispatch(dispatchedAction);
      };

      store.dispatch(action);

      expect(store.state, dispatchedAction);
    });

    test('dispatches an async action from ThunkActions', () async {
      final store = new Store<String>(
        identityReducer,
        middleware: [thunkMiddleware],
      );
      final dispatchedAction = "Friend";
      final future = new Future<String>(
        () => dispatchedAction,
      );
      final action = (Store<String> store) async {
        final result = await future;

        store.dispatch(result);
      };

      store.dispatch(action);

      await future;

      expect(
        future.then((_) => store.state),
        completion(dispatchedAction),
      );
    });
  });
}
