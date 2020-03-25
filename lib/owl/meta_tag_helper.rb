module MetaTagHelper
  def meta_ajax_page
    content_for(:meta_ajax_page) { '<meta name="fragment" content="!">'.html_safe }
  end

  def meta_canonical_page(page_path)
    content_for(:meta_canonical_page) { "<link rel=\"canonical\" href=\"https://#{Rails.application.default_url_options[:host]}#{page_path}\"/>".html_safe }
  end

  # Установить мета тег description на странице
  def meta_description(page_description)
    content_for(:meta_description) { "<meta name=\"description\" content=\"#{page_description}\">".html_safe }
  end

  # Установить мета тег keywords на странице
  def meta_keywords(page_keywords)
    content_for(:meta_keywords) { "<meta name=\"keywords\" content=\"#{page_keywords}\">".html_safe }
  end

  def meta_robots(page_robots)
    content_for(:meta_robots) { "<meta name=\"robots\" content=\"#{page_robots}\">".html_safe }
  end
end
