module Effective
  class TrashController < ApplicationController
    if respond_to?(:before_action) # Devise
      before_action :authenticate_user!
    else
      before_filter :authenticate_user!
    end

    # This is the User index event
    def index
      @datatable = Effective::Datatables::Trash.new(user_id: current_user.id)
      @page_title = 'Trash'

      EffectiveTrash.authorized?(self, :index, Effective::Trash.new(user_id: current_user.id))
    end

    # This is the User show event
    def show
      @trash = Effective::Trash.where(user_id: current_user.id).find(params[:id])
      @page_title = "Trash item - #{@trash.to_s}"

      EffectiveTrash.authorized?(self, :show, @trash)
    end

    def restore
      @trash = Effective::Trash.all.find(params[:id])
      EffectiveTrash.authorized?(self, :update, @trash)

      Effective::Trash.transaction do
        begin
          @trash.restore!
          flash[:success] = "Successfully restored #{@trash}"
        rescue => e
          flash[:danger] = "Unable to restore: #{e.message}"
          raise ActiveRecord::Rollback
        end
      end

      redirect_back(fallback_location: effective_trash.trash_path)
    end

  end
end
