odule Effective
  class Trash < ActiveRecord::Base
    self.table_name = EffectiveTrash.trash_table_name.to_s

    belongs_to :trashed, polymorphic: true  # The original item type and id. Note that this object will never exist as it's deleted.
    belongs_to :user, optional: true  # The user that destroyed the original resource

    # Attributes
    # trashed_type       :string
    # trashed_id         :integer
    # trashed_to_s       :string
    # trashed_extra      :string

    # details            :text
    # timestamps

    serialize :details, Hash

    default_scope -> { order(updated_at: :desc) }

    def to_s
      [trashed_type, trashed_id].join(' ').presence || 'New Trash item'
    end

    def details
      self[:details] || {}
    end

    # So this is a Trash item
    # When we delete ourselves, we restore this trash item first
    def restore_trash!
      raise 'no attributes to restore from' unless details.kind_of?(Hash) && details[:attributes].present?
      trashed_type.constantize.new(details[:attributes]).save!
    end

  end
end


