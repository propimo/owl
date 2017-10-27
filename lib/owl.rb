require 'active_record'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), '/owl')) + "/**/*.rb"].each do |file|
  require file
end
