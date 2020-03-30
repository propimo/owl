require 'rails/generators'

module WebpackWithGems
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('./', __dir__)

    def copy_gems_resolver
      copy_file "bin/gem_resolver", "bin/gem_resolver"
      File.chmod(0777,"bin/gem_resolver")
    end

    def copy_loader
      copy_file "loader/gem.js", "config/webpack/loaders/gem.js"
    end

    def include_loader_call
      webpack_config_path = 'config/webpack/environment.js'
      export_str = "module.exports = environment;"
      js_include = <<-JS
const { resolvedGems } = require('./loaders/gem');
  resolvedGems['gems'].forEach((gemPair) => {
  environment.resolvedModules.add({
    key: gemPair['gem_name'],
    value: gemPair['gem_path']
  });
});
JS

      inject_into_file webpack_config_path, before: export_str do
        js_include
      end
    end
  end
end
