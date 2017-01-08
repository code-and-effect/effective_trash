# Effective Trash

Simple Trash restore functionality for Active Record objects.

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

The `acts_as_trashable` mixin sets up `before_destroy` hook and copies the now-deleted attributes to an `Effective::Trash` object.

Visit `/trash`, or `/admin/trash` to restore them.

## Admin Screen

To use the Admin screen, please also install the [effective_datatables](https://github.com/code-and-effect/effective_datatables/) gem:

```ruby
gem 'effective_datatables'
```

Then you should be able to visit:

```ruby
link_to 'Trash', effective_trash.trash_index_path   # /trash
link_to 'Trash', effective_trash.admin_trash_index_path   # /admin/trash
```

But you may need to add the permission (using CanCan):

```ruby
can [:index, :show, :restore], Effective::Trash, user_id: user.id

# Admin
can :manage, Effective::Trash
can :admin, :effective_trash
```

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Testing

The test suite for this gem is unfortunately not yet complete.

Run tests by:

```ruby
rake spec
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request

