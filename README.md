[![Gem Version](https://badge.fury.io/rb/spectacles.svg)](https://badge.fury.io/rb/spectacles)

# Spectacles

Spectacles adds database view functionality to ActiveRecord. It is heavily inspired by Rails SQL Views (created by https://github.com/aeden but no longer maintained) and built from the ground up to work with Rails.

Spectacles provides the ability to create views in migrations using a similar format to creating tables. It also provides an abstract view class that inherits from `ActiveRecord::Base` that can be used to create view-backed models.

It currently works with the SQLite, MySQL2, PostgreSQL, and Vertica drivers.

# Using Spectacles

Install it

```shell
$ gem install spectacles # => OR include it in your Gemfile
```

## Migrations

Create a migration from an query string:

```ruby
create_view :product_users do
  "SELECT name AS product_name, first_name AS username FROM products JOIN users ON users.id = products.user_id"
end
```

Create a migration from an ARel object:

```ruby
create_view :product_users do
  Product.select("products.name AS product_name).select("users.first_name AS username").join(:users)
end
```

## Models

```ruby
class ProductUser < Spectacles::View # Add relationships
  # Use scopes

  # Your fancy methods
end
```

## Materialized Views

_This feature is only supported for PostgreSQL backends._

These are essentially views that cache their result set. In this way they are kind of a cross between tables (which persist data) and views
(which are windows onto other tables).

```ruby
create_materialized_view :product_users do
  <<-SQL.squish
    SELECT name AS product_name, first_name AS username
    FROM products
    JOIN users ON users.id = products.user_id
  SQL
end

class ProductUser < Spectacles::MaterializedView # just like Spectacles::View
end
```

Because materialized views cache a snapshot of the data as it exists at a point in time (typically when the view was created), you
need to manually _refresh_ the view when new data is added to the original tables. You can do this with the `#refresh!` method on
the `Spectacles::MaterializedView` subclass:

```ruby
User.create(first_name: "Bob", email: "bob@example.com")
ProductUser.refresh!
```

Also, you can specify a few different options to `create_materialized_view` to affect how the new view is created:

- `:force` - if `false` (the default), the create will fail if a
  materialized view with the given name already exists. If `true`,
  any materialized view with that name will be dropped before the
  create runs.

  ```ruby
  create_materialized_view :product_users, force: true do
    # ...
  end
  ```

- `:data` - if `true` (the default), the view is immediately populated
  with the corresponding data. If `false`, the view will be empty initially,
  and must be populated by invoking the `#refresh!` method.

  ```ruby
  create_materialized_view :product_users, data: false do
    # ...
  end
  ```

- `:columns` - an optional array of names to give the columns in the view.
  By default, columns in the view will use the names given in the query.

  ```ruby
  create_materialized_view :product_users, columns: %i(product_name username) do
    <<-SQL.squish
    SELECT products.name, users.first_name
    FROM products
    JOIN users ON users.id = products.user_id
    SQL
  end
  ```

- `:tablespace` - an optional identifier (string or symbol) indicating
  which namespace the materialized view ought to be created in.

  ```ruby
  create_materialized_view :product_users, tablespace: "awesomesauce" do
    # ...
  end
  ```

- `:storage` - an optional hash of (database-specific) storage parameters to
  optimize how the materialized view is stored. (See
  http://www.postgresql.org/docs/9.4/static/sql-createtable.html#SQL-CREATETABLE-STORAGE-PARAMETERS
  for details.)

  ```ruby
  create_materialized_view :product_users, storage: { fillfactor: 70 } do
    # ...
  end
  ```

# License

Spectacles is licensed under MIT license (Read the LICENSE file for full license)
