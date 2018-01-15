module Decoratable
  extend ActiveSupport::Concern

  module ClassMethods
    def decorator_class(name)
      camelized_name = name.to_s.camelize
      const_get(camelized_name)
    rescue NameError
      raise NoDecoratorError, "Decorator #{camelized_name} is not defined"
    end

    def presenter_class
      decorator_class(:presenter)
    end

    def decorate(*args)
      all.map { |item| item.decorate(*args) }
    end

    def present
      presenter_class.wrap_collection(all)
    end
  end

  def decorator_class(name)
    self.class.decorator_class(name)
  end

  def presenter_class
    self.class.presenter_class
  end

  def present
    presenter_class.new(self)
  end

  def decorate(*args)
    decorators = args.reduce([]) { |arr, decorator| decorator == :presenter ? arr << decorator : arr.unshift(decorator) }
    decorators.reduce(self) do |result, arg|
      next arg.reduce(result) { |memo, pair| decorator_class(pair.first).new(memo, *pair.last) } if arg.respond_to?(:to_h)
      decorator_class(arg).new(result)
    end
  end

  class NoDecoratorError < StandardError
  end
end
