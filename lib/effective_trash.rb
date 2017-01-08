require 'haml-rails'
require 'effective_trash/engine'
require 'effective_trash/version'

module EffectiveTrash

  # The following are all valid config keys
  mattr_accessor :trash_table_name

  mattr_accessor :authorization_method
  mattr_accessor :layout
  mattr_accessor :trash_enabled

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

end
