require 'rails'
require 'breadcrumbs_on_rails'

class CustomBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder
  def initialize(context, elements, options = {})
    super
    @options[:separator] = ''
  end

  def render
    divider = '<i class="fa fa-circle"></i>'
    @context.render "/shared/breadcrumbs", elements: @elements, divider: divider, css_class: 'page-breadcrumb'
  end

  def render_element(element)
    # with microdata
    if element.path == nil
      content = compute_name(element)
    else
      content = @context.link_to_unless_current(
          @context.content_tag(:span, compute_name(element), itemprop: 'title'),
          compute_path(element), itemprop: 'url')
    end
    content = @context.content_tag(:li, content,
                                   itemscope: 'itemscope', itemtype: 'http://data-vocabulary.org/Breadcrumb')
  end
end
