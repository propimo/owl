module Messegable
  # Создает метод возвращающий переданную строку или добавляющий в строку элементы по шаблону
  # см. https://apidock.com/ruby/Kernel/format
  # @param [Symbol] method_name имя метода
  # @param [String] message сообщение или шаблон сообщения
  def define_message(method_name, message)
    define_method(method_name) do |*args|
      if args.present?
        sprintf(message, *args)
      else
        message
      end
    end
  end
end
