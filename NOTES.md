# NOTES

## Level 1:
- To add `total` I changed 2 constructors (BooksScreen, CartBadge) in 3 files: main.dart, books_screen.dart, cart_badge.dart.
- One tap on Add printed 7 lines. setState in Shell rebuilds everything below it.

## Level 2: A model with no widgets
- Cart is a plain ChangeNotifier and imports only foundation.dart. It printed `1 items, 3100 ₸` before the first frame.
- `cart.items.add(...)` throws `Unsupported operation: Cannot add to an unmodifiable list`.

## Level 3: The same app with provider
- Loud error (`context.watch` in the Add button): `Tried to listen to a value exposed with provider, from outside of the widget tree.`
- Silent error (`context.read` in the badge): no error, but the badge stays at 0 forever, because nothing subscribes to the cart.

- Tried to listen to a value exposed with provider, from outside of the widget tree.

- This is likely caused by an event handler (like a button's onPressed) that called
- Provider.of without passing `listen: false`.
- To fix, write:
- Provider.of<Cart>(context, listen: false);


## Level 4: Scope
- Badge rebuilds, 3 presses of + with context.watch: 3
- Badge rebuilds, 3 presses of + with context.select: 0

## Where does it live?
- The cart: provided. The badge, books screen and cart screen all need it, so it is a ChangeNotifier above MaterialApp.
- Search text: ephemeral. Only the Books screen uses it, so it stays in that screen's State.
- Total expanded or collapsed: ephemeral. Only one widget needs it, so it is a bool in its own State.
- Theme mode: provided. MaterialApp reads it at the top and a switch somewhere else changes it, so it must live above both.