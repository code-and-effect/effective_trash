require 'effective_resources'
require 'effective_trash/engine'
require 'effective_trash/version'

module EffectiveTrash

  def self.config_keys
    [
      :trash_table_name, :layout, :routes_enabled
    ]
  end

  include EffectiveGem

  # This is set by the "set_effective_trash_current_user" before_filter.
  def self.current_user=(user)
    @effective_trash_current_user = user
  end

  def self.current_user
    @effective_trash_current_user
  end

  # Trash it - Does not delete the original object.
  # This is run in a before_destroy, or through a script.
  def self.trash!(obj)
    args = (obj.respond_to?(:acts_as_trashable_options) ? obj.acts_as_trashable_options : {})
    details = Effective::Resource.new(obj).instance_attributes(only: args[:only], except: args[:except])

    trash = Effective::Trash.new(
      trashed: obj,
      user: EffectiveTrash.current_user,
      trashed_to_s: obj.to_s,
      trashed_extra: obj.try(:trashed_extra),
      details: details
    ).save!
  end

end
