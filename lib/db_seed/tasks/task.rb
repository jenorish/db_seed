module DbSeed
  class Task < Rails::Railtie
    rake_tasks do
      Rake::Task["db:seed"].clear
      namespace :db do
        task seed: [:environment, :load_config] do
          md5, md5_checksum, seed_object = find_md5
          if md5_checksum == md5
            puts "Already db/seeds.rb loaded .."
          else
            Rake::Task["db:abort_if_pending_migrations"].invoke
            ::ActiveRecord::Tasks::DatabaseTasks.load_seed
            seed_object.update_column(:md5_checksum, md5)
          end
        end

        task create_md5_checksum: [:environment, :load_config] do
          md5, md5_checksum, seed_object = find_md5
          seed_object.update_column(:md5_checksum, md5) if md5_checksum.blank?
        end

        def find_md5
          file_path = File.expand_path("db/seeds.rb")
          md5 = Digest::MD5.file(file_path).hexdigest
          seed_object = DbSeed::ActiveRecord::Seed.first_or_create(md5_checksum: nil)
          md5_checksum = seed_object.try(:md5_checksum)
          return md5, md5_checksum, seed_object
        end
      end
    end
  end
end