module Viewable
  extend ActiveSupport::Concern

  included do
    has_many :view_counters_today, -> { where(date: Date.today) }, as: :item, class_name: 'ViewCounter'
    has_many :view_counters_yesterday, -> { where(date: Date.yesterday) }, as: :item, class_name: 'ViewCounter'
    has_many :view_counters_per_month, -> { where(date: 1.month.ago..Date.today) }, as: :item, class_name: 'ViewCounter'
    has_many :view_counters_per_year, -> { where(date: 1.year.ago..Date.today) }, as: :item, class_name: 'ViewCounter'
  end

  # Количество просмотров сегодня
  # @return [Integer]
  def views_today
    view_counters_today.sum(&:views_count)
  end

  # Количество просмотров вчера
  # @return [Integer]
  def views_yesterday
    view_counters_yesterday.sum(&:views_count)
  end

  # Количество просмотров за год
  # @return [Integer]
  def views_per_year
    view_counters_per_year.sum(&:views_count)
  end

  # Количество просмотров за месяц
  # @return [Integer]
  def views_per_month
    view_counters_per_month.sum(&:views_count)
  end

  # Среднее количество просмотров за сутки
  # @return [Integer]
  def views_per_day
    ViewCounter.where(item: self).where('date < ?', Date.today).average(:views_count).to_i
  end
end
