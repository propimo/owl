require_relative '../utils/assets'

class NonDigestAssets
  ALLOWED_ASSETS = ['booking_widget.js']

  def initialize(app)
    @app = app
  end

  def call(env)
    asset_path = env['PATH_INFO'].sub('/assets/', '')
    status, headers, response = @app.call(env)
    if ALLOWED_ASSETS.include?(asset_path)
      asset = Utils::Assets.render_asset_to_string(asset_path)
      headers['Content-Length'] = asset.length.to_s
      response = [asset]
      status = 200
    end
    [status, headers, response]
  end
end
