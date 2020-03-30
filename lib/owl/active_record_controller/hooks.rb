module ActiveRecordController
  module Hooks
    def default_index_hook
      add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"

      @page_title = t(:index, scope: plural_resource_name)
    end

    def default_show_hook
      add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"
    end

    def default_new_hook
      add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"
      add_breadcrumb t(:new, scope: plural_resource_name)

      @page_title = t(:new, scope: plural_resource_name)
    end

    def default_edit_hook
      add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"
      add_breadcrumb t(:edit, scope: plural_resource_name)

      @page_title = t(:edit, scope: plural_resource_name)
    end
  end
end
