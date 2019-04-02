require 'effective_resources'
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
    @_exceptions ||= [Effective::AccessDenied, (CanCan::AccessDenied if defined?(CanCan)), (Pundit::NotAuthorizedError if defined?(Pundit))].compact

    return !!authorization_method unless authorization_method.respond_to?(:call)
    controller = controller.controller if controller.respond_to?(:controller)

    begin
      !!(controller || self).instance_exec((controller || self), action, resource, &authorization_method)
    rescue *@_exceptions
      false
    end
  end

  def self.authorize!(controller, action, resource)
    raise Effective::AccessDenied unless authorized?(controller, action, resource)
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
    args = (obj.respond_to?(:acts_as_trashable_options) ? obj.acts_as_trashable_options : {})

    trash = Effective::Trash.new(
      trashed: obj,
      user: EffectiveTrash.current_user,
      trashed_to_s: obj.to_s,
      trashed_extra: (trashed_extra if obj.respond_to?(:trashed_extra)),
      details: Effective::Resource.new(obj).instance_attributes(args)
    ).save!
  end

end
