module OwlViewHelper

    # Добавляет блок в который кладет ошибку ajax-form к соответствующему полю
    # @param [Symbol|String] object_id Имя поля ошибки
    # @param [String] default_text Текст по умолчанию
    # @param [String] css_class
    # @param [String] style
    # @example
    #  danger_help_block(:email)
    # @return [String] html safe string
    def danger_help_block(object_id, default_text: nil, css_class: nil, style: nil)
    <<-HTML.html_safe
      <span id='#{object_id}' 
            class='help-block text-danger #{css_class}' 
            style='display: none; #{style}'
      >
       #{default_text}
      </span>
    HTML
    end

    # @param [FormObject] form Объекты формы
    # @param [ActiveRecord] obj Сущность над которой производится действие
    # @param [Boolean] hide_show_btn Скрытие кнопки "Показать"
    # @param [String] confirm_message Сообщение при подтверждении удаления
    # @param [String] show_obj_path Путь к экшену show данной сущности
    # @return [String] html safe tag
    def render_control_buttons(form:, obj:, hide_show_btn: false, confirm_message:, show_obj_path: nil)
      render partial: 'owl_view_helper/control_buttons',
             locals: {
                 form: form,
                 obj: obj,
                 show_obj_path: show_obj_path,
                 hide_show_btn: hide_show_btn,
                 confirm_message: confirm_message
             }
    end

    # @param [Pagination] pagination
    # @return [String] html safe
    def render_pagination(pagination)
      render partial: 'owl_view_helper/pagination',
             locals: {
               pagination: pagination
             }
    end

    # Использует иконки из методов show_icon_tag, remove_icon_tag, edit_icon_tag
    # Чтобы использовать другие иконки нужно переопределить их
    # @param [ActiveRecord] obj Сущность над которой производится действие
    # @param [String] edit_obj_path Путь к экшену edit данной сущности
    # @param [String] confirm_message Сообщение при подтверждении удаления
    # @param [Boolean] hide_show_btn Скрытие кнопки "Показать"
    # @param [Boolean] hide_delete_btn Скрытие кнопки "Удалить"
    # @param [String] show_obj_path Путь к экшену show данной сущности
    # @param [Hash] button_opts Хэш для классов кнопок
    #   param [String] show_btn_class
    #   param [String] edit_btn_class
    #   param [String] remove_btn_class
    #   param [String] group_btns
    # @return [Object]
    def render_compact_control_buttons(obj:,
                                       edit_obj_path:,
                                       confirm_message: nil,
                                       hide_show_btn: false,
                                       hide_delete_btn: false,
                                       show_obj_path: nil,
                                       button_opts: nil)
      default_opts = {
        show_btn_class: 'btn btn-default',
        edit_btn_class: 'btn btn-default',
        remove_btn_class: 'btn btn-default',
        group_btns: 'btn-group btn-group-sm pull-right',
      }

      default_opts.merge!(button_opts)

      render partial: 'owl_view_helper/compact_control_buttons',
             locals: {
               obj: obj,
               hide_show_btn: hide_show_btn,
               hide_delete_btn: hide_delete_btn,
               show_obj_path: show_obj_path,
               edit_obj_path: edit_obj_path,
               confirm_message: confirm_message,
               button_opts: default_opts,
             }
    end

    def show_icon_tag
      <<-HTML.html_safe
        <i class="glyphicon glyphicon-eye-open"></i>
      HTML
    end

    def edit_icon_tag
      <<-HTML.html_safe
        <i class="glyphicon glyphicon-pencil"></i>
      HTML
    end

    def remove_icon_tag
      <<-HTML.html_safe
        <i class="glyphicon glyphicon-remove"></i>
      HTML
    end
end
