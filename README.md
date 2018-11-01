# redux_thunk

[![Build Status](https://travis-ci.org/brianegan/redux_thunk.svg?branch=master)](https://travis-ci.org/brianegan/redux_thunk) [![codecov](https://codecov.io/gh/brianegan/redux_thunk/branch/master/graph/badge.svg)](https://codecov.io/gh/brianegan/redux_thunk)

[Redux](https://pub.dartlang.org/packages/redux) provides a simple way to update a your application's State in response to synchronous Actions. However, it lacks tools to handle asynchronous code. This is where Thunks come in.

The `thunkMiddleware` intercepts and calls `ThunkAction`s, which is simply a fancy name for any function that takes 1 argument: a Redux Store. This allows you to dispatch functions (aka `ThunkAction`s) to your Store that can perform asynchronous work, then dispatch actions using the Store after the work is complete.

The dispatched `ThunkAction`s will be swallowed, meaning they will not go through the rest of your middleware to the `Store`'s `Reducer`.

### Example

```dart
// First, create a quick reducer
State reducer(String state, action) =>
    action is String ? action : state;

// Next, apply the `thunkMiddleware` to the Store
final store = new Store<String>(
  reducer,
  middleware: [thunkMiddleware],
);

// Create a `ThunkAction`, which is any function that accepts the 
// Store as it's only argument. Our function (aka ThunkAction) will
// simply send an action after 1 second.  This is just an example, 
// but  in real life, you could make a call to an HTTP service or 
// database instead!
void action(Store<String> store) async {
  final searchResults = await new Future.delayed(
    new Duration(seconds: 1),
    () => "Search Results",
  );

  store.dispatch(searchResults);
}

// You can also use a function with some parameters to create a thunk, 
// and then use it like so: store.dispatch(waitAndDispatch(3));
ThunkAction<String> waitAndDispatch(int secondsToWait) {
  return (Store<String> store) async {
    final searchResults = await new Future.delayed(
      new Duration(seconds: secondsToWait),
      () => "Search Results",
    );

    store.dispatch(searchResults);
  };
}


```
    
## Credits

All the ideas in this lib are shamelessly stolen from the original [redux-thunk](https://github.com/gaearon/redux-thunk) library and simply adapted to Dart.  
