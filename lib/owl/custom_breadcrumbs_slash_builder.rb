require_relative 'custom_breadcrumbs_builder'

class CustomBreadcrumbsSlashBuilder < CustomBreadcrumbsBuilder
  def render
    divider = '<span class="divider">/</span>'
    @context.render "/shared/breadcrumbs", elements: @elements, divider: divider, css_class: 'breadcrumb'
  end
end
