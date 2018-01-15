require_relative 'module_template'

module Snippets
  # DSL для активации сниппетов в полях класса
  # @example
  #   enable_snippets in: [:page_description, :title, :h1, :meta_description] do
  #     sight { sight.name }
  #     sight_locative { sight.genitive }
  #   end
  module DSL
    def enable_snippets(in:, &block)
      fields = binding.local_variable_get(:in)
      fields = fields.respond_to?(:to_a) ? fields.to_a : [fields]

      define_method :fields_with_snippets do
        fields | (defined?(super) ? super : [])
      end

      module_template = Snippets::ModuleTemplate.new(fields)
      module_template.instance_exec(&block)

      prepend module_template.compile
    end
  end
end
