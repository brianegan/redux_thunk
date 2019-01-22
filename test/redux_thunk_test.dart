import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:test/test.dart';

void main() {
  String identityReducer(String state, dynamic action) =>
      action is String ? action : state;

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

    group('ThunkCallableAction', () {
      test('dispatches successfully when no error thrown', () async {
        final store = new Store<String>(
          identityReducer,
          middleware: [thunkMiddleware],
        );

        final dispatchValue = "Friend";
        var action = new TestAction(dispatchValue);
        store.dispatch(action);

        expect(store.state, dispatchValue);

        String onCompleteValue = await action.onComplete;
        expect(onCompleteValue, dispatchValue);
      });

      test('completes the onComplete future with an error when one occurs', () async {
        final store = new Store<String>(
          identityReducer,
          middleware: [thunkMiddleware],
        );

        var action = new TestErrorAction();
        store.dispatch(action);

        expect(store.state, null);

        expect(action.onComplete, throwsException);
      });
    });
  });
}

class TestAction extends ThunkCallableAction<String> {
  final String value;

  TestAction(this.value);

  @override
  FutureOr call(Store<String> store) async {
    store.dispatch(value);
    return value;
  }
}

class TestErrorAction extends ThunkCallableAction<String> {
  TestErrorAction();

  @override
  FutureOr call(Store<String> store) async {
    throw Exception('Oh noes!');
  }
}