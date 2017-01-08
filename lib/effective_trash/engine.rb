module EffectiveTrash
  class Engine < ::Rails::Engine
    engine_name 'effective_trash'

    config.autoload_paths += Dir["#{config.root}/lib/"]

    # Set up our default configuration options.
    initializer "effective_trash.defaults", before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_trash.rb")
    end

    # Include acts_as_loggable concern and allow any ActiveRecord object to call it with log_changes()
    initializer 'effective_trash.active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.extend(ActsAsTrashable::ActiveRecord)
      end
    end

    # Register the log_page_views concern so that it can be called in ActionController or elsewhere
    initializer 'effective_trash.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.include(EffectiveTrash::TrashableUser)
        ActionController::Base.send(:before_action, :set_effective_trash_current_user)
      end
    end

  end
end
