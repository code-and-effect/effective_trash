module Effective
  class Trash < ActiveRecord::Base
    self.table_name = EffectiveTrash.trash_table_name.to_s

    belongs_to :trashed, polymorphic: true  # The original item type and id. Note that this object will never exist as it's deleted.
    belongs_to :user # The user that destroyed the original resource

    # Attributes
    # trashed_type       :string
    # trashed_id         :integer
    # trashed_to_s       :string
    # trashed_extra      :string

    # details            :text
    # timestamps

    if EffectiveResources.serialize_with_coder?
      serialize :details, type: Hash, coder: YAML
    else
      serialize :details, Hash
    end

    scope :deep, -> { includes(:user, :trashed) }
    scope :sorted, -> { order(:id) }

    def to_s
      trashed_to_s.presence || [trashed_type, trashed_id].join(' ').presence || 'New Trash item'
    end

    def details
      self[:details] || {}
    end

    def to_object
      raise 'no attributes to consider' unless details.kind_of?(Hash) && details[:attributes].present?

      resource = Effective::Resource.new(trashed_type)
      object = trashed_type.constantize.new(details[:attributes])

      resource.nested_resources.each do |association|
        if details[association.name].present? && object.respond_to?("#{association.name}_attributes=")
          nested_attributes = details[association.name].inject({}) do |h, (index, nested)|
            h[index] = nested[:attributes].except('id', association.inverse_of&.foreign_key); h
          end

          object.send("#{association.name}_attributes=", nested_attributes)
        end
      end

      object
    end

    # So this is a Trash item
    # When we delete ourselves, we restore this trash item first
    def restore!
      to_object.save!(validate: false)
      destroy!
    end

  end
end


