# bundle exec rails generate effective_trash:trash_archived_booleans

module EffectiveTrash
  module Generators
    class TrashArchivedBooleansGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Upgrade all tables from boolean archived implementation. Trash all previously archived records'

      source_root File.expand_path('../../template', __FILE__)

      def self.next_migration_number(dirname)
        if not ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime('%Y%m%d%H%M%S')
        else
          '%.3d' % (current_migration_number(dirname) + 1)
        end
      end

      def create_migration_file
        migration_template ('../' * 3) + 'db/trash/trash_archived_booleans.rb', 'db/migrate/trash_archived_booleans.rb'
      end
    end
  end
end
