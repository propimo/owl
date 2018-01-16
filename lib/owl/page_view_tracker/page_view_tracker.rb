# Класс для отслеживания просмотров страниц сущностей
class PageViewTracker
  # @param counter_class [Class] Класс модели каунтера
  def initialize(counter_class)
    @counter_class = counter_class
  end

  # Метод отслеживания просмотров страниц сущностей
  # @param item [ApplicationRecord]
  # @param request [ActionDispatch::Request]
  # @param date [Date]
  def call(item, request, date: Date.today)
    browser = Browser.new(request.user_agent)
    counter = @counter_class.find_or_create_by(item: item, date: date)
    @counter_class.increment_counter(browser.bot? ? :bot_views_count : :views_count, counter.id)
  end
end
