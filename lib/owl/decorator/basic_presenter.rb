require_relative 'basic_decorator'

class BasicPresenter < BasicDecorator
  protected
    def helpers
      ApplicationController.helpers
    end
end
