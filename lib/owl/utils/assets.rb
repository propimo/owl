module Utils
  module Assets
    extend self

    def render_asset_to_string(asset_name)
      return Rails.application.assets[asset_name].to_s.html_safe if Rails.env.development?
      File.read("#{Rails.root}/public/assets/#{Rails.application.assets_manifest.files.map { |k, v| k if v['logical_path'] == asset_name }.compact.last}").html_safe
    end
  end
end
