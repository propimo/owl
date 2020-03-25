require 'owl'
require 'rails'

module Owl
  # Автоматически загружает таски
  class Railtie < Rails::Railtie
    railtie_name :owl

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
