# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module DbSeed
  # Installs PaperTrail in a rails app.
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    # Class names of MySQL adapters.
    # - `MysqlAdapter` - Used by gems: `mysql`, `activerecord-jdbcmysql-adapter`.
    # - `Mysql2Adapter` - Used by `mysql2` gem.
    MYSQL_ADAPTERS = %w(ActiveRecord::ConnectionAdapters::MysqlAdapter ActiveRecord::ConnectionAdapters::Mysql2Adapter).freeze

    source_root File.expand_path("templates", __dir__)


    desc "Generates (but does not run) a migration to add a Active Record Seeds table."

    def create_migration_file
      add_seed_migration("create_active_record_seed")
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_seed_migration(template)
      migration_dir = File.expand_path("db/migrate")
      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
            "#{template}.rb.erb",
            "db/migrate/#{template}.rb",
            migration_version: migration_version
        )
      end
    end

    private

    def migration_version
      major = ::ActiveRecord::VERSION::MAJOR
      if major >= 5
        "[#{major}.#{::ActiveRecord::VERSION::MINOR}]"
      end
    end

    # Even modern versions of MySQL still use `latin1` as the default character
    # encoding. Many users are not aware of this, and run into trouble when they
    # try to use PaperTrail in apps that otherwise tend to use UTF-8. Postgres, by
    # comparison, uses UTF-8 except in the unusual case where the OS is configured
    # with a custom locale.
    #
    # - https://dev.mysql.com/doc/refman/5.7/en/charset-applications.html
    # - http://www.postgresql.org/docs/9.4/static/multibyte.html
    #
    # Furthermore, MySQL's original implementation of UTF-8 was flawed, and had
    # to be fixed later by introducing a new charset, `utf8mb4`.
    #
    # - https://mathiasbynens.be/notes/mysql-utf8mb4
    # - https://dev.mysql.com/doc/refman/5.5/en/charset-unicode-utf8mb4.html
    #
  end
end