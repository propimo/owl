class Settings
  delegate :each, :map, to: :to_h

  # @param [AbstractAdapter] connection соединение с БД
  # @param [String] table название таблицы
  def initialize(connection, table: 'settings')
    @connection, @table = connection, table
  end

  # Получает значение из таблицы настроек по ключу
  # @param [String, Symbol] key
  # @return [Object]
  def [](key)
    query = <<-SQL
      SELECT value FROM #{@table} WHERE key = #{@connection.quote(key)}
    SQL
    result = @connection.execute(query).to_a.first
    return unless result
    YAML.load(result['value'])
  end

  # Задаёт значение соответствующему ключу в таблице настроек
  # @param [String, Symbol] key
  # @param [Object] value
  def []=(key, value)
    key_exists = !!self[key]
    quoted_key = @connection.quote(key)
    quoted_value = @connection.quote(value.to_yaml)

    query =
      if key_exists
        <<-SQL
          UPDATE #{@table} SET value = #{quoted_value} WHERE #{@table}.key = #{quoted_key}
        SQL
      else
        <<-SQL
          INSERT INTO #{@table} (key, value) VALUES (#{quoted_key}, #{quoted_value})
        SQL
      end
    # TODO: вернуть, когда обновим постгрес
    # query = <<-SQL
    #   INSERT INTO #{@table} (key, value)
    #   VALUES (#{quoted_key}, #{quoted_value})
    #   ON CONFLICT (key) DO
    #   UPDATE SET value = #{quoted_value} WHERE #{@table}.key = #{quoted_key}
    # SQL
    @connection.execute(query)
  end

  def to_h
    query = <<-SQL
      SELECT key, value FROM #{@table}
    SQL
    result = @connection.execute(query).to_a
    result.map { |setting| { setting['key'] => YAML.load(setting['value']) } }.reduce(:merge).with_indifferent_access
  end
end
