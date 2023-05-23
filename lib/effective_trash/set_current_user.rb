module EffectiveTrash
  module SetCurrentUser
    module ActionController

      # Add me to your ApplicationController
      # before_action :set_effective_trash_current_user

      def set_effective_trash_current_user
        begin
          EffectiveTrash.current_user = current_user
          yield
        ensure
          EffectiveTrash.current_user = nil
        end
      end

    end
  end
end
