module EffectiveTrash
  class Engine < ::Rails::Engine
    engine_name 'effective_trash'

    config.autoload_paths += Dir["#{config.root}/lib/"]

    # Set up our default configuration options.
    initializer "effective_trash.defaults", before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_trash.rb")
    end

    # Include acts_as_trashable concern and allow any ActiveRecord object to call it with acts_as_trashable()
    initializer 'effective_trash.active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.extend(ActsAsTrashable::ActiveRecord)
      end
    end

    # Register the log_page_views concern so that it can be called in ActionController or elsewhere
    initializer 'effective_trash.action_controller' do |app|
      Rails.application.config.to_prepare do
        ActiveSupport.on_load :action_controller do
          ActionController::Base.include(EffectiveTrash::SetCurrentUser::ActionController)
        end
      end
    end

  end
end
