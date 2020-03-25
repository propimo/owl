namespace :db do
  # Производит строку с аргументами командной строки, в которой ключи хэша являются параметрами,
  # а соответствующие им значения - значениями данных параметров
  # @param [Hash] hash хэш, содержащий параметры командной строки, разбитые на пары
  # @param [Array] keys ключи хэша, из которых необходимо составить строку с параметрами
  # @param [:Symbol] type форма записи генерируемых аргументов
  #   @option :long "длинная" форма записи
  #   @option :short "короткая" форма записи
  # @param [Boolean] prepend_arg отделять сгенерированные аргументы командной строки от аргументов предыдущей команды
  # @raise [StandardError] при попытке передать в качестве хэша что-либо, отличное от хэша, а также при попытке
  # передать неизвестную форму записи аргументов
  # @example Стандартное использование
  #   opts_string({a : 1, b: 'word'}) #=> "--a=1 --b=word"
  # @example Включение определенных параметров
  #   opts_string({a : 1, b: 'word'}, keys: [:a]) #=> "--a=1"
  # @example Отделить параметры от параметров предыдущей команды
  #   opts_string({a : 1, b: 'word'}, prepend_arg: true) #=> "-- --a=1 --b=word"
  # @example Отделить параметры от параметров предыдущей команды
  #   opts_string({a : 1, b: 'word'}, type: short) #=> "-a 1 -b word"
  # @return [String]
  def opts_string(hash, keys: [], type: :long, prepend_arg: false)
    raise StandardError, "Argument 'options' must be a Hash type!" unless hash.kind_of?(Hash)

    known_types = %i[long short]
    raise StandardError, "Unknown value #{type} for option 'type'" unless type.in?(known_types)

    pattern = ->(opt, arg) do
      case type
        when :short
          "-#{opt} #{arg}"
        else
          "--#{opt}=#{arg}"
      end
    end

    keys = hash.keys if keys.blank?
    keys = keys.map(&:to_sym)

    opts = hash.slice(*keys)
    opts_array = opts.map { |opt, value| pattern.call(opt, value) }
    opts_array = opts_array.unshift('--') if prepend_arg
    opts_array.join(' ')
  end

  task update_local: :environment do
    raise StandardError, 'This task cannot be executed in production environment!' if Rails.env.production?

    parser = TaskOptionParser.new
    options = parser.parse!

    Rake::Task['db:dump:download'].invoke(opts_string(options, keys: %i[remote_db dump host user], prepend_arg: true))
    Rake::Task['db:restore'].invoke(opts_string(options, keys: %i[local_db dump], prepend_arg: true))
  end
end
