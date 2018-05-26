// First, create a quick reducer
final reducer = (String state, action) =>
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
final action = (Store<String> store) async {
  final searchResults = await new Future.delayed(
    new Duration(seconds: 1),
    () => "Search Results",
  );

  store.dispatch(searchResults);
};
