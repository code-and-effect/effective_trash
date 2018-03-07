module EffectiveTrash
  module SetCurrentUser
    module ActionController

      # Add me to your ApplicationController
      # before_action :set_effective_trash_current_user

      def set_effective_trash_current_user
        EffectiveTrash.current_user = current_user
      end

    end
  end
end

