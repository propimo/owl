module Utils
  module Html
    extend self

    # Возвращает строку, в которой пробелы заменены на <br>
    # @param [String] str
    # @return [String]
    def space_to_br(str)
      str.gsub(/\s+/, " <br/>").html_safe
    end

    # Хелпер для рендера docx-файла в html
    # @param file_path [string] путь к файлу на сервере
    # @param params [Hash] хэш для реплейса плейсхолдеров вида "{ключ}" на значение
    # @yieldparam [string] paragraph передаёт каждый абзац в переданный блок
    def render_docx(file_path, params = {})
      doc = Docx::Document.open(file_path)
      result = ''
      doc.paragraphs.each do |p|
        params.each { |k, v| p.text = p.text.gsub("{#{k.to_s}}", v.to_s) }
        html_paragraph = p.to_html
        block_given? ? yield(html_paragraph.html_safe) : result += html_paragraph
      end
      result.html_safe
    end

    def mask_from_phone(phone)
      code_length = phone.slice(/\(\d+\)/).size - 2
      case code_length
        when 3
          '(999) 999-99-99'
        when 4
          '(9999) 99-99-99'
        else
          raise NotImplementedError
      end
    end

    def bool_glyphicon(bool)
      return '' if bool.nil?
      "<i class='glyphicon glyphicon-#{(bool ? 'ok\' style="color:green;"' : 'remove\' style="color:red;"')}></i>".html_safe
    end

    def yes_no_html(is_something)
      (is_something ? '<i class="glyphicon glyphicon-ok" style="color: green;"></i> Да' : '<i class="glyphicon glyphicon-remove" style="color: red;"></i> Нет').html_safe
    end
 
    # Хелпер, возвращающий ту же строку, если она не пустая, либо заглушку, переданную в параметре dummy
    def string_or_dummy(str, dummy = '')
      str.present? ? str : dummy.html_safe
    end
  end
end
