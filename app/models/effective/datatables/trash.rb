if Gem::Version.new(EffectiveDatatables::VERSION) < Gem::Version.new('3.0')
  module Effective
    module Datatables
      class Trash < Effective::Datatable
        include EffectiveTrashHelper

        datatable do
          default_order :created_at, :desc

          table_column :created_at, label: 'Destroyed at'
          table_column :id, visible: false

          unless attributes[:user_id] || attributes[:user] || (attributes[:user] == false)
            table_column :user, label: 'Destroyed by'
          end

          table_column :trashed_type, label: 'Type'
          table_column :trashed_id, label: 'Original Id', visible: false
          table_column :trashed_to_s, label: 'Item'

          table_column :details, visible: false, sortable: false do |trash|
            tableize_hash(trash.details, th: true, sub_th: false, width: '100%')
          end

          unless attributes[:actions] == false
            actions_column partial: 'admin/trash/actions', partial_local: :trash
          end
        end

        # A nil attributes[:log_id] means give me all the top level log entries
        # If we set a log_id then it's for sub trash
        def collection
          collection = Effective::Trash.all.includes(:user)

          if attributes[:user_id].present?
            collection = collection.where(user_id: attributes[:user_id])
          end

          if attributes[:user].present?
            collection = collection.where(user: attributes[:user])
          end

          if attributes[:trashed_id] && attributes[:trashed_type]
            collection = collection.where(trashed_id: attributes[:trashed_id], trashed_type: attributes[:trashed_type])
          end

          collection
        end

      end
    end
  end
end
