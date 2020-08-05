module DestroyRestriction
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :destroy_restrictions

    # Запрещает удалять модель, если выполнится условие из коллбэка
    # @param [Proc, Symbol] if
    # @param [String, Symbol] attribute название атрибута, который будет добавлен в ошибки вместе с сообщением
    # @param [String, Proc] message сообщение, которое будет добавлено в ошибки (строка, либо лямбда, которая будет выполнена в контексте экземпляра класса)
    def restricts_destroy(if: -> { true }, attribute: '', message: 'Невозможно удалить объект')
      condition_callback = binding.local_variable_get(:if).to_proc
      self.destroy_restrictions << { condition: condition_callback, message: message }

      before_destroy do
        errors.add(attribute, eval_restriction_message(message)) && throw(:abort) if exec_condition(condition_callback)
      end
    end

    def destroy_restrictions
      @destroy_restrictions ||= []
    end
  end

  # Может ли объект быть удалён
  # @return [Boolean]
  def can_be_destroyed?
    self.class.destroy_restrictions.none? { |restriction| exec_condition(restriction[:condition]) }
  end

  # Сообщение об ошибке в случае невозможности удаления
  # @param [String] delimiter разделитель между сообщениями
  # @return [String]
  def destroy_restriction_message(delimiter: ' ')
    messages = self.class.destroy_restrictions.map do |restriction|
      exec_condition(restriction[:condition]) ? eval_restriction_message(restriction[:message]) : nil
    end
    messages.compact.join(delimiter)
  end

  private
    def exec_condition(condition)
      condition.lambda? ? instance_exec(&condition) : instance_exec(&proc { condition.(self) })
    end

    def eval_restriction_message(message)
      message.respond_to?(:call) ? exec_condition(message) : message
    end
end
