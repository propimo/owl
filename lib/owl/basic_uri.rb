class BasicUri #< URI::Generic

  # Конструктор
  # @param[String] uri_string - строковое представление URI
  def initialize(uri_string)
    @uri = URI(uri_string)
  end

  class << self
    # Генерирует альтернативный url для заданной локали на основе заданного url
    # @param original_url [String] исходная ссылка
    # @param locale [Symbol] локаль, для которой сгенерировать ссылку
    # @return [String] url на заданную страницу на другом языке
    def alternate_url(original_url, locale)
      lang_in_url = Regexp.new("/#{I18n.locale}(?=/|$)")

      if original_url.match?(lang_in_url) # если в original_url есть /ru/ или оканчивается на /ru
        original_url.sub(lang_in_url, "/#{locale}")

        # иначе если original_url оканчивается на / (ссылка на главную)
      elsif original_url.last == '/'
        "#{original_url}#{locale}"

        # иначе original_url содержит только домен (ссылка на главную)
      else
        "#{original_url}/#{locale}"
      end
    end

    # Генерирует альтернативные url для заданной локали на основе заданного url
    # @param original_url [String] исходная ссылка
    # @param locale [Symbol] локаль, для которой не нужно генерировать ссылку (которой принадлежит заданная ссылка)
    # @return [Hash<Symbol, String>] url на заданную страницу на других языках
    def alternate_urls(original_url, locale)
      alternative_urls = {}
      I18n.available_locales
          .reject { |l| l == locale }
          .each { |l| alternative_urls[l] = BasicUri.alternate_url(original_url, l) }
      alternative_urls
    end
  end

  # Заменяет для параметра page значение на заданное число
  # Если page_number < 2, то параметр удаляется
  # @param page_number [String] номер страницы
  # @return [String] строковое представление URI
  def change_page_number(page_number)
    if page_number > 1
      change_uri_param('page', page_number)
    else
      delete_uri_param('page')
    end
  end

  # Заменяет для параметра key значение на value
  # @param key [String] наименование параметра
  # @param value [String] значение параметра
  # @return [String] строковое представление URI
  def change_uri_param(key, value)
    uri_params = @uri.query.present? ? Hash[URI.decode_www_form(@uri.query)] : {}
    uri_params[key] = value
    @uri.query = uri_params.to_param
    @uri.to_s
  end

  # Удаляет паарметр key
  # @param key [String] наименование параметра
  # @return [String] строковое представление URI
  def delete_uri_param(key)
    if @uri.query.present?
      uri_params = Hash[URI.decode_www_form(@uri.query)]

      uri_params.delete(key)
      @uri.query = uri_params.empty? ? nil : uri_params.to_param
    end

    @uri.to_s
  end
end
