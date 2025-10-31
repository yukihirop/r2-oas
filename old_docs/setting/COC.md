# ❗️Convention over Configuration (CoC)

- `tag name` represents `controller name` and determine `paths file name`.
  - For example, If `controller name` is `Api::V1::UsersController`, `tag_name` is `api/v1/user`. and `paths file name` is `api/v1/user.yml`

- `_` of `components/{schemas,requestBodies, ...} name` convert `/` when save file.
  - For example, If `components/schemas name` is `Api_V1_User`, `components/schemas file name` is `api/v1/user.yml`.
  - `_` is supposed to be used to express `namespace`.
  - format is `Namespace1_Namespace2_Model`.

- `.` of `components/{schemas,requestBodies, ...} name` convert `/` when save file.
  - For example, If `components/schemas name` is `api.v1.User`, `components/schemas file name` is `api/v1/user.yml`.
  - `.` is supposed to be used to express `namespace`.
  - format is `namespace1.namespace2.Model`.
