# Effective Trash

Simple Trash and Restore functionality for any Active Record object.

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
  before_action :set_effective_trash_current_user
end
```

## How it works

The `acts_as_trashable` mixin sets up `before_destroy` and serializes the resource's attributes to an `Effective::Trash` object.

It also serializes the attributes of any `belongs_to`, `has_one`, and `has_many` with `accepts_nested_attributes` related resources.

Restoring only works with the single base object right now.

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

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request

