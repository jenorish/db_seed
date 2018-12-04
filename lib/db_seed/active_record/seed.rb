require 'active_record'

module DbSeed
  module ActiveRecord
    class Seed < ::ActiveRecord::Base
      self.table_name = 'db_seeds'
    end
  end
end