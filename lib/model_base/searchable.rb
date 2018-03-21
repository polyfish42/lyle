require_relative 'db_connection'
require_relative 'model_base'

module Searchable
  def where(params)
    where_line = params.keys.map {|k| " #{k} = ? "}.join('AND')

    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

    results.map {|result| self.new(result)}
  end
end

class ModelBase
  extend Searchable
end
