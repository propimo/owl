module Snippets
  class ModuleTemplate
    # @param [Array] fields
    # @param [Proc] condition
    def initialize(fields, condition = -> { true })
      @fields, @condition = fields, condition
      @contexts = []
      @snippets = {}
    end
  
    # Добавляет контекстно-зависимый блок сниппетов
    # @param [Proc] condition
    # @return [Array<Snippets::ModuleTemplate>]
    def context(condition, &block)
      contextual_template = self.class.new(@fields, condition)
      contextual_template.instance_exec(&block)
      @contexts << contextual_template
    end
  
    # Генерирует анонимный модуль с методами, переопределяющими поля со сниппетами
    # @return [Module]
    def compile
      fields = @fields
      snippets_evaluator = -> (object) { evaluate_snippets(object) }
  
      Module.new do
        fields.each do |field|
          define_method field do
            raw_value = super() || return
            evaluated_snippets = snippets_evaluator.call(self)
            raw_value.gsub(/\{(.*?)\}/) { evaluated_snippets[$1.to_sym] || "{#{$1}}" }
          end
  
          define_method "#{field}_raw" do
            method(field).super_method.call
          end
        end
      end
    end
  
    # Вычисляет значения полей со сниппетами
    # @param [Object] object
    # @return [Hash]
    def evaluate_snippets(object)
      return {} unless object.instance_exec(&@condition)
      snippets_hash = @snippets.map { |k, v| { k => v.respond_to?(:call) ? object.instance_exec(&v) : v } }.reduce(:merge) || {}
      contextual_hash = @contexts.map { |c| c.evaluate_snippets(object) }.reduce(:merge) || {}
      snippets_hash.merge(contextual_hash)
    end
  
    def method_missing(name, *args, &block)
      add_snippet(name, *args, &block)
    end
  
    private
      # Добавление сниппета в шаблон модуля
      # @param [String, Symbol] name
      # @param [Object] value
      def add_snippet(name, value = nil, &block)
        @snippets[name] = value ? value : block
      end
  end
end
