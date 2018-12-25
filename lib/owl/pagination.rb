# Класс пагинации. Работает как с ActiveRecord::Relation, так и с массивами
class Pagination
  # Размер страницы по умолчанию
  DEFAULT_PAGE_SIZE = 30

  attr_accessor :page_size, :current_page, :pages_count, :items

  # Инициализатор пагинации.
  # @param items [ActiveRecord::Relation, Array] коллекция элементов для пагинации
  # @option options [Integer] :page_size  размер страницы
  # @option options [Integer] :current_page  номер текущей страницы
  # @option options [Integer] :items_count  общее количество элементов для пагинации
  # @yieldparam [Pagination] pagination передаёт саму себя в переданный блок
  # @example Создание пагинации
  #   pagination = Pagination.new(Book.all, current_page: 3, page_size: 20)
  #   pagination = Pagination.new(Book.all) do |pagination| pagination.page_size = 40 end
  def initialize(items, options = {})
    options.each { |k, v| instance_variable_set("@#{k.to_s}", v) }
    yield self if block_given?

    @page_size ||= DEFAULT_PAGE_SIZE
    @current_page = 1 if @current_page.blank? || @current_page == 0

    @items_count = items.size if @items_count.blank?
    @pages_count = (@items_count % @page_size == 0) ? @items_count / @page_size : (@items_count / @page_size) + 1
    if items.respond_to? :limit
      @items = items.limit(@page_size).offset(@page_size * (@current_page - 1))
    elsif items.respond_to? :[]
      @items = items.drop(@page_size * (@current_page - 1)).first(@page_size)
    end
  end
end
