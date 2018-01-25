require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
DB = File.join(Dir.pwd, 'db/')

class DBConnection
  def self.sql_file(sql_file)
    @@sql_file = sql_file
  end

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
    db_file = "#{DB}#{File.basename(@@sql_file, '.sql')}.db"

    commands = [
      "rm '#{db_file}'",
      "cat '#{@@sql_file}' | sqlite3 '#{db_file}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(db_file)
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
