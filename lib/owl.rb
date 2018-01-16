require 'active_record'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), '/owl')) + "/**/*.rb"].each do |file|
  require file
end

module Owl
  ROOT_PATH = File.expand_path '../..', __FILE__

  BROWSERS = YAML::load_file(File.join(ROOT_PATH, 'config', 'browser_updater.yml'))
end
