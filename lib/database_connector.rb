class DatabaseConnector
  class << self
    def establish_connection
      ActiveRecord::Base.logger = Logger.new('config/debug.log')

      configuration = YAML::load(IO.read('config/database.yml'))

      ActiveRecord::Base.establish_connection(configuration)
    end
  end
end
