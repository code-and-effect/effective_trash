# Effective Trash

Trash and Restore any Active Record object.

## Getting Started

Add to your Gemfile:

```ruby
gem 'effective_trash'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_trash:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table name (to use something other than the default 'trash'), manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

## Usage

Add to your model:

```ruby
class Post < ActiveRecord::Base
  acts_as_trashable
end
```

and to your contoller:

```ruby
class ApplicationController < ActionController::Base
  around_action :set_effective_trash_current_user
end
```

## How it works

The `acts_as_trashable` mixin sets up `before_destroy` and serializes the resource's attributes to an `Effective::Trash` object.

It also serializes the attributes of any `belongs_to`, `has_one`, and `has_many` with `accepts_nested_attributes` related resources.

Restoring only works with the single base object right now.

`acts_as_trashable include_associated: false` for cheaper trashes that don't to_s every object.

`acts_as_trashable include_nested: false` will ignore any nested_attributes, but careful you can lose data when true.

## Routes

Visit `/trash`, or `/admin/trash` for an interface to view and restore Trash.

```ruby
link_to 'Trash', effective_trash.trash_index_path   # /trash
link_to 'Admin Trash', effective_trash.admin_trash_index_path   # /admin/trash
```

## Permissions

Add the following permissions (using CanCan):

```ruby
can :manage, Effective::Trash, user_id: user.id

# Admin
can :manage, Effective::Trash
can :admin, :effective_trash
```

The user must be permitted to to `:update` an `Effective::Trash` in order to restore the trashed item.

## Upgrade database from archived booleans

Use the following generator, to produce a database migration:

```
rails generate effective_trash:trash_archived_booleans
```

The migration will trash all `archived?` objects, delete them, and replace the archived boolean on the corresponding database table.

This upgrades from this gem author's previous archived implementation, which was:

- Use an `archived` boolean on each model.
- Call the model by a scope (or default scope, yuck) somehting like `Post.where(archived: false)`.

Don't do that.

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
