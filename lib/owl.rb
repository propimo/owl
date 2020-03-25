require 'active_record'
require 'i18n'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), '/owl')) + "/**/*.rb"].each do |file|
  require file
end

module Owl
  ROOT_PATH = File.expand_path '../..', __FILE__
  CONFIG_PATH = File.join(ROOT_PATH, 'config')

  BROWSERS = YAML::load_file(File.join(ROOT_PATH, 'config', 'browser_updater.yml'))

  require 'owl/railtie' if defined?(Rails)
end

ActiveSupport.on_load(:i18n) do
  I18n.load_path << File.expand_path("../config/locales/en.yml", __dir__)
  I18n.load_path << File.expand_path("../config/locales/ru.yml", __dir__)
end
