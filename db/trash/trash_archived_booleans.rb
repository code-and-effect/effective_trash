class TrashArchivedBooleans < ActiveRecord::Migration[4.2]
  def self.up
    Rails.application.eager_load!
    klasses = ActiveRecord::Base.descendants
      .reject { |klass| klass.abstract_class? }
      .select { |klass| (klass.new.respond_to?(:archived?) rescue false) }

    klasses.each do |klass|
      puts "Trashing #{klass.table_name}"

      ids = [] # to delete

      klass.unscoped.where(archived: true).find_each do |resource|
        print '.'
        EffectiveTrash.trash!(resource)
        ids << resource.id
      end

      klass.where(id: ids).delete_all
    end

    klasses.each { |klass| remove_column(klass.table_name, :archived) }
  end

  def self.down
    raise 'TODO: this could be written'
  end
end
