require_relative 'db_connection'
require 'active_support/inflector'
require_relative 'associatable'
require_relative 'searchable'

class ModelBase
  def self.columns
    if @columns
      @columns
    else
      table = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
      SQL
      @columns = table.fields.map(&:to_sym)
    end
  end

  def self.finalize!
    columns

    if @columns
      @columns.each do |col|
        define_method(col) do
          attributes[col]
        end

        setter = "#{col}=".to_sym

        define_method(setter) do |value|
          attributes[col] = value
        end
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= ActiveSupport::Inflector.tableize(self.to_s)
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    instances = []

    results.each do |result|
      instances << self.new(result)
    end

    instances
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = #{id}
    SQL

    return nil if result.empty?

    self.new(result[0])
  end

  def initialize(params = {})
    params.each do |(attr_name, value)|
      sym = attr_name.to_sym

      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(sym)

      setter = "#{attr_name}=".to_sym
      self.send(setter, value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end

  def insert
    cols = self.class.columns - [:id]
    col_names = cols.join(",")
    question_marks = Array.new(cols.length).map.with_index {|_, i| "$#{i + 1}"}.join(",")

    id = DBConnection.execute(<<-SQL, attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
      RETURNING
        id
    SQL

    self.id = id
    self
  end

  def update
    cols = self.class.columns.reject {|k, _| k == :id}
    set_clause = cols.map.with_index {|(k, _), i| "#{k} = ?"}.join(",")

    result = DBConnection.execute(<<-SQL, attribute_values.rotate)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_clause}
      WHERE
        id = ?
    SQL
  end

  def save
    if self.id.nil?
      insert
    else
      update
    end
  end
end
