import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:test/test.dart';

void main() {
  String identityReducer(String state, dynamic action) =>
      action is String ? action : state;

  group('thunkMiddleware', () {
    test('intercepts and handles synchronous ThunkActions', () {
      final store = Store<String>(
        identityReducer,
        middleware: [thunkMiddleware],
      );
      void action(Store<String> store) => store.dispatch('A');

      store.dispatch(action);

      expect(store.state, 'A');
    });

    test('intercepts and handles synchronous CallableThunkActions', () {
      final store = Store<String>(
        identityReducer,
        middleware: [thunkMiddleware],
      );

      store.dispatch(SyncThunk());

      expect(store.state, 'A');
    });

    test('dispatches an async action from ThunkActions', () async {
      final store = Store<String>(
        identityReducer,
        middleware: [thunkMiddleware],
      );
      Future<void> action(Store<String> store) async {
        final result = await Future<String>.value('A');

        store.dispatch(result);
      }

      await store.dispatch(action);

      expect(store.state, 'A');
    });

    test('dispatches an async action from CallableThunkActions', () async {
      final store = Store<String>(
        identityReducer,
        middleware: [thunkMiddleware],
      );

      await store.dispatch(AsyncThunk());

      expect(store.state, 'A');
    });
  });

  group('ExtraArgumentThunkMiddleware', () {
    test('handles sync ThunkActionWithExtraArgument', () {
      final store = Store<String>(
        identityReducer,
        middleware: [ExtraArgumentThunkMiddleware<String, int>(1)],
      );
      void action(Store<String> store, int arg) => store.dispatch('$arg');

      store.dispatch(action);

      expect(store.state, '1');
    });

    test('handles sync CallableThunkActionWithExtraArgument', () {
      final store = Store<String>(
        identityReducer,
        middleware: [ExtraArgumentThunkMiddleware<String, int>(1)],
      );

      store.dispatch(SyncExtra());

      expect(store.state, '1');
    });

    test('handles async ThunkActionWithExtraArgument', () async {
      final store = Store<String>(
        identityReducer,
        middleware: [ExtraArgumentThunkMiddleware<String, int>(1)],
      );
      Future<void> action(Store<String> store, int extra) async {
        await Future<void>.value();

        store.dispatch('$extra');
      }

      await store.dispatch(action);

      expect(store.state, '1');
    });

    test('handles async CallableThunkActionWithExtraArgument', () async {
      final store = Store<String>(
        identityReducer,
        middleware: [ExtraArgumentThunkMiddleware<String, int>(1)],
      );

      await store.dispatch(AsyncExtra());

      expect(store.state, '1');
    });
  });
}

class SyncThunk implements CallableThunkAction<String> {
  @override
  void call(Store<String> store) {
    store.dispatch('A');
  }
}

class AsyncThunk implements CallableThunkAction<String> {
  @override
  Future<void> call(Store<String> store) async {
    await Future.value('I');
    store.dispatch('A');
  }
}

class SyncExtra implements CallableThunkActionWithExtraArgument<String, int> {
  @override
  void call(Store<String> store, int extraArgument) {
    store.dispatch('$extraArgument');
  }
}

class AsyncExtra implements CallableThunkActionWithExtraArgument<String, int> {
  @override
  Future<void> call(Store<String> store, int extraArgument) async {
    await Future<void>.value();

    store.dispatch('$extraArgument');
  }
}
