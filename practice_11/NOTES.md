# Practice 11 - NOTES

## Level 1 - Postman

- `GET /users` -> **200**, `Content-Type: application/json; charset=utf-8`, body is a JSON **array of 10** users.
- `GET /users/1` -> 200, a single object (no envelope, no `data` key).
- `GET /users?id=3` -> 200, **a list of one** user, not an object.

### User (top level)

| field    | JSON type | Dart type | nullable? |
|----------|-----------|-----------|-----------|
| id       | number (int) | int    | no |
| name     | string    | String    | no |
| username | string    | String    | no |
| email    | string    | String    | no |
| phone    | string (free format, e.g. `1-770-736-8031 x56442`) | String (+ `phoneDigits` getter) | no |
| website  | string    | String?   | **yes** (treated as optional) |
| address  | object    | Address   | no |
| company  | object    | Company record `({String name, String catchPhrase})` | no |

### address

| field   | JSON type | Dart type | nullable? |
|---------|-----------|-----------|-----------|
| street  | string | String | no |
| suite   | string | String | no |
| city    | string | String | no |
| zipcode | string | String | no |
| geo     | object (**nested twice**: address.geo) | Geo | no |

### address.geo

| field | JSON type | Dart type | nullable? |
|-------|-----------|-----------|-----------|
| lat   | **string** (`"-37.3159"`) | double (`double.parse`) | no |
| lng   | **string** (`"81.1496"`)  | double (`double.parse`) | no |

### company

| field       | JSON type | Dart type | nullable? |
|-------------|-----------|-----------|-----------|
| name        | string | String | no |
| catchPhrase | string | String | no |
| bs          | string | (not modelled) | no |

### Errors and writes

- `GET /users/999` -> **404 Not Found**, body `{}` (empty object). Decoding it succeeds, so the status must be checked **before** the body.
- `POST /users` (JSON body + `Content-Type: application/json`) -> **201 Created**; the server echoes what was sent and **adds `id`: 11**.

Status -> exception map used by `ApiClient._check`: 401 -> `UnauthorizedException`, 404 -> `NotFoundException`, >= 500 -> `ServerException(status)`, other non-2xx -> `BadResponseException`.

## Level 5 - two kinds of "no network"

| test | what happened | time |
|------|---------------|------|
| Airplane mode, pull to refresh | Offline view | TODO: ~0.x s (write your number) |
| Wi-Fi with no internet (hotspot), pull to refresh | Offline view | TODO: ~10 s (write your stopwatch number) |

DevTools -> Network: `/users` row without status and ~10 000 ms -> `screenshot_timeout.png`; a 200 row with body -> `screenshot_200.png`.
