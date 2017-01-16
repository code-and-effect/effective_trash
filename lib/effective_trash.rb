require 'haml-rails'
require 'effective_trash/engine'
require 'effective_trash/version'

module EffectiveTrash

  # The following are all valid config keys
  mattr_accessor :trash_table_name

  mattr_accessor :authorization_method
  mattr_accessor :layout
  mattr_accessor :routes_enabled

  def self.setup
    yield self
  end

  def self.authorized?(controller, action, resource)
    if authorization_method.respond_to?(:call) || authorization_method.kind_of?(Symbol)
      raise Effective::AccessDenied.new() unless (controller || self).instance_exec(controller, action, resource, &authorization_method)
    end
    true
  end

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
    trash = Effective::Trash.new(
      trashed: obj,
      user: EffectiveTrash.current_user,
      trashed_to_s: obj.to_s,
      trashed_extra: (trashed_extra if obj.respond_to?(:trashed_extra)),

      details: EffectiveTrash::ActiveRecordSerializer.new(obj, obj.try(:acts_as_trashable_options)).attributes
    ).save!
  end

end
