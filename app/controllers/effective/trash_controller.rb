module Effective
  class TrashController < ApplicationController
    before_action :authenticate_user!

    # This is the User index event
    def index
      @datatable = EffectiveTrashDatatable.new(self, user_id: current_user.id)

      @page_title = 'Trash'

      EffectiveResources.authorize!(self, :index, Effective::Trash.new(user_id: current_user.id))
    end

    # This is the User show event
    def show
      @trash = Effective::Trash.where(user_id: current_user.id).find(params[:id])
      @page_title = "Trash item - #{@trash.to_s}"

      EffectiveResources.authorize!(self, :show, @trash)
    end

    def restore
      @trash = Effective::Trash.find(params[:id])
      EffectiveResources.authorize!(self, :update, @trash)

      Effective::Trash.transaction do
        begin
          @trash.restore!
          flash[:success] = "Successfully restored #{@trash}"
        rescue => e
          flash[:danger] = "Unable to restore: #{e.message}"
          raise ActiveRecord::Rollback
        end
      end

      if request.referer.to_s.include?(effective_trash.admin_trash_index_path)
        redirect_to effective_trash.admin_trash_index_path
      else
        redirect_to effective_trash.trash_index_path
      end

    end

  end
end
