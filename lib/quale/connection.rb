require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
ROOT_FOLDER = File.join(File.dirname(__FILE__), '../../sample/db')
SAMPLE_SQL_FILE = File.join(ROOT_FOLDER, 'sample.sql')
SAMPLE_DB_FILE = File.join(ROOT_FOLDER, 'sample.db')

class DBConnection
  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '~'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '~'
  end

  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{SAMPLE_DB_FILE}'",
      "cat '#{SAMPLE_SQL_FILE}' | sqlite3 '#{SAMPLE_DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(SAMPLE_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end
