class EffectiveTrashDatatable < Effective::Datatable
  datatable do
    order :created_at, :desc

    col :created_at, label: 'Destroyed at'
    col :id, visible: false

    unless attributes[:user_id] || attributes[:user] || (attributes[:user] == false)
      col :user, label: 'Destroyed by'
    end

    col :trashed_type, label: 'Type'
    col :trashed_id, label: 'Original Id', visible: false
    col :trashed_to_s, label: 'Item'

    col :details, visible: false do |trash|
      tableize_hash(trash.details)
    end

    unless attributes[:actions] == false
      actions_col partial: 'admin/trash/actions', partial_as: :trash
    end
  end

  # A nil attributes[:log_id] means give me all the top level log entries
  # If we set a log_id then it's for sub trash
  collection do
    collection = Effective::Trash.deep.all

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
