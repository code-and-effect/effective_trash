module EffectiveTrash
  class ActiveRecordSerializer
    attr_accessor :resource, :options

    def initialize(resource, options = {})
      options ||= {}
      raise ArgumentError.new('options must be a Hash') unless options.kind_of?(Hash)

      @resource = resource
      @options = options
    end

    def attributes
      attributes = { attributes: resource.attributes }

      # Collect to_s representations of all belongs_to associations
      (resource.class.try(:reflect_on_all_associations, :belongs_to) || []).each do |association|
        attributes[association.name] = resource.send(association.name).to_s.presence
      end

      # Collect to_s representations for all has_one associations
      (resource.class.try(:reflect_on_all_associations, :has_one) || []).each do |association|
        next if association.name == :trash && resource.respond_to?(:acts_as_trashable_options) # We skip our own association
        attributes[association.name] = resource.send(association.name).to_s.presence
      end

      # Collects attributes for all accepts_as_nested_parameters has_many associations
      (resource.class.try(:reflect_on_all_autosave_associations) || []).each do |association|
        attributes[association.name] = {}

        Array(resource.send(association.name)).each_with_index do |child, index|
          attributes[association.name][index+1] = ActiveRecordSerializer.new(child, options).attributes
        end
      end

      attributes.delete_if { |k, v| v.blank? }
    end

    private

    # TODO: Make this work better with nested objects
    def applicable(attributes)
      atts = if options[:only].present?
        attributes.slice(*options[:only])
      elsif options[:except].present?
        attributes.except(*options[:except])
      else
        attributes.except(:updated_at, :created_at)
      end

      (options[:additionally] || []).each do |attribute|
        value = (resource.send(attribute) rescue :effective_trash_nope)
        next if attributes[attribute].present? || value == :effective_trash_nope

        atts[attribute] = value
      end

      atts
    end

  end
end
