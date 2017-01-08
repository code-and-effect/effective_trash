module EffectiveLogging
  module TrashableUser

    # This is automatically mixed into ActionController::Base via
    # before_action :set_effective_logging_current_user

    def set_effective_trash_current_user
      if respond_to?(:current_user)
        EffectiveTrash.current_user = current_user
      else
        raise "(effective_trash) set_effective_trash_current_user expects a current_user() method to be available"
      end
    end

  end
end

