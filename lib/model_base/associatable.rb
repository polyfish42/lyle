require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    ActiveSupport::Inflector.constantize(self.class_name)
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    under_name = ActiveSupport::Inflector.underscore(name)
    camel_name = ActiveSupport::Inflector.camelize(name)
    camel_name = ActiveSupport::Inflector.singularize(camel_name)
    defaults = {
      foreign_key: "#{under_name}_id".to_sym,
      class_name: "#{camel_name}",
      primary_key: :id
    }

    defaults.merge(options).each do |opt, val|
      setter = "#{opt}=".to_sym

      self.send(setter, val)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    under_name = ActiveSupport::Inflector.underscore(self_class_name)
    camel_name = ActiveSupport::Inflector.camelize(name)
    camel_name = ActiveSupport::Inflector.singularize(camel_name)
    defaults = {
      foreign_key: "#{under_name}_id".to_sym,
      class_name: "#{camel_name}",
      primary_key: :id
    }

    defaults.merge(options).each do |opt, val|
      setter = "#{opt}=".to_sym

      self.send(setter, val)
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      foreign_key = self.send(options.foreign_key)

      options.model_class.where({options.primary_key => foreign_key}).first
    end

    assoc_options[name.to_sym] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      primary_key = self.send(options.primary_key)

      options.model_class.where({options.foreign_key => primary_key})
    end
  end

  def assoc_options
    @options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]

      results = DBConnection.execute(<<-SQL)
        SELECT
          #{source_options.table_name}.*
        FROM
          #{source_options.table_name}
        JOIN
          #{through_options.table_name}
        ON
          #{source_options.foreign_key} = #{source_options.table_name}.#{source_options.primary_key}
        WHERE
          #{through_options.table_name}.#{through_options.primary_key} = #{self.send(through_options.foreign_key)}
        SQL
        source_options.model_class.send(:new, results.first)
    end
  end
end

class ModelBase
  extend Associatable
end
