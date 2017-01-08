# This copies the permissions of The Logs controller

module Admin
  class TrashController < ApplicationController
    respond_to?(:before_action) ? before_action(:authenticate_user!) : before_filter(:authenticate_user!) # Devise

    layout (EffectiveTrash.layout.kind_of?(Hash) ? EffectiveTrash.layout[:admin_trash] : EffectiveTrash.layout)

    helper EffectiveTrashHelper

    def index
      @datatable = Effective::Datatables::Trash.new()
      @page_title = 'Trash'

      EffectiveTrash.authorized?(self, :index, Effective::Trash)
      EffectiveTrash.authorized?(self, :admin, :effective_trash)
    end

    def show
      @trash = Effective::Trash.all.find(params[:id])
      @page_title = "Trash item - #{@trash.to_s}"

      EffectiveTrash.authorized?(self, :show, @trash)
      EffectiveTrash.authorized?(self, :admin, :effective_trash)
    end
  end
end
