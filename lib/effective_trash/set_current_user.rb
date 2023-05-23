module EffectiveTrash
  module SetCurrentUser
    module ActionController

      # Add me to your ApplicationController
      # around_action :set_effective_trash_current_user

      def set_effective_trash_current_user
        EffectiveTrash.current_user = current_user

        if block_given?
          retval = yield
          EffectiveTrash.current_user = nil
          retval
        end
      end

    end
  end
end
