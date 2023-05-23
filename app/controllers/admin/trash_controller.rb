# This copies the permissions of The Logs controller

module Admin
  class TrashController < ApplicationController
    before_action :authenticate_user!

    layout (EffectiveTrash.layout.kind_of?(Hash) ? EffectiveTrash.layout[:admin_trash] : EffectiveTrash.layout)

    def index
      @datatable = EffectiveTrashDatatable.new(self)

      @page_title = 'Trash'

      EffectiveResources.authorize!(self, :index, Effective::Trash)
      EffectiveResources.authorize!(self, :admin, :effective_trash)
    end

    def show
      @trash = Effective::Trash.all.find(params[:id])
      @page_title = "Trash item - #{@trash.trashed_to_s}"

      EffectiveResources.authorize!(self, :show, @trash)
      EffectiveResources.authorize!(self, :admin, :effective_trash)
    end
  end
end
