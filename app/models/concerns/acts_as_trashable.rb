module ActsAsTrashable
  extend ActiveSupport::Concern

  module ActiveRecord
    def acts_as_trashable(*options)
      @acts_as_trashable_options = options.try(:first) || {}

      unless @acts_as_trashable_options.kind_of?(Hash)
        raise ArgumentError.new("invalid arguments passed to (effective_trash) acts_as_trashable.")
      end

      if (unknown = (@acts_as_trashable_options.keys - [:only, :except])).present?
        raise ArgumentError.new("unknown keyword: #{unknown.join(', ')}")
      end

      include ::ActsAsTrashable
    end
  end

  included do
    has_one :trash, as: :trashed, class_name: 'Effective::Trash'

    before_destroy do
      EffectiveTrash.trash!(self)
    end

    # Parse Options
    acts_as_trashable_options = {
      only: Array(@acts_as_trashable_options[:only]),
      except: Array(@acts_as_trashable_options[:except]),
    }

    self.send(:define_method, :acts_as_trashable_options) { acts_as_trashable_options }
  end

  module ClassMethods
    def acts_as_trashable?; true; end
  end

  # Regular instance methods

end
