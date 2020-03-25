# Базовый класс для контроллера для ActiveRecord модели
# - предоставляет базовые экшены CRUD для контроллеров:
# index, show, new, edit, create, update, destroy,
# которые можно подключить каждый по необходимости.
#
# Пример:
#
#  class UsersController < ActionController::Base
#     include BasicActiveRecordController
#     init_resource :user
#     define_actions :index, :show, :new, :edit, :create, :update, :destroy
#   end
#
# - предоставляет шаблонные методы index_hook, show_hook, new_hook, edit_hook, create_hook
# для соответствующих экшенов контроллера, необходимые для определения пользовательских опций
# - предоставляет @object для доступа во вьюхах всех экшенов, кроме index
# - предоставляет @objects для доступа во вьюхах экшена index
module ActiveRecordController
  module Base
    extend ActiveSupport::Concern

    included do
      class_attribute :resource_name
      class_attribute :controller_scope, default: 'admin'

      class << self
        # Задает имя модели, связанной с контроллером
        # @param name [Symbol] имя модели в единственном числе
        def init_resource(name, controller_scope: nil)
          self.resource_name = name
          self.controller_scope = controller_scope if controller_scope.present?
        end

        # Определяет экшены контроллера из списка заданных:
        # index (+ index_hook),
        # show (+ show_hook),
        # new (+ new_hook),
        # edit (+ edit_hook),
        # create,
        # update,
        # destroy
        # @param attrs [Array<Symbol>] список экшенов, которые необходимо предоставить
        def define_actions(*attrs)
          define_index_action if attrs.include?(:index)
          define_show_action if attrs.include?(:show)
          define_new_action if attrs.include?(:new)
          define_edit_action if attrs.include?(:edit)
          define_create_action if attrs.include?(:create)
          define_update_action if attrs.include?(:update)
          define_destroy_action if attrs.include?(:destroy)
        end

        # Определяет экшен index (+ index_hook)
        def define_index_action
          # GET /object
          # GET /object.json
          define_method(:index) do
            @objects = model.all

            index_hook

            respond_to do |format|
              format.html { render action_path('index') }
              format.json { render json: @objects }
            end
          end

          # Хук для страницы индекса
          # Устанавливает хлебную крошку страницы индекса и заголовок страницы по-умолчанию
          define_method(:index_hook) do
            add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"

            @page_title = t(:index, scope: plural_resource_name)
          end
        end

        # Определяет экшен show (+ show_hook)
        def define_show_action
          # GET /object/1
          # GET /object/1.json
          define_method(:show) do
            @object = model.find(params[:id])

            show_hook

            respond_to do |format|
              format.html { render action_path('show') }
              format.json { render json: @object }
            end
          end

          # Хук для страницы просмотра
          # Устанавливает хлебную крошку страницы индекса по-умолчанию
          define_method(:show_hook) do
            add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"
          end
        end

        # Определяет экшен new (+ new_hook)
        def define_new_action
          # GET /object/new
          # GET /object/new.json
          define_method(:new) do
            @model_klass_sym_plural = plural_resource_name

            @object = model.new

            new_hook

            respond_to do |format|
              format.html { render action_path('new') rescue render 'active_record_controller/new' }
              format.json { render json: @object }
            end
          end

          # Хук для страницы создания сущности
          # Устанавливает хлебную крошку страницы индекса, страницы создания и заголовок страницы по-умолчанию
          define_method(:new_hook) do
            add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"
            add_breadcrumb t(:new, scope: plural_resource_name)

            @page_title = t(:new, scope: plural_resource_name)
          end
        end

        # Определяет экшен edit (+ edit_hook)
        def define_edit_action
          # GET /object/1/edit
          define_method(:edit) do
            # TODO
            @model_klass_sym_plural = plural_resource_name

            @object = model.find(params[:id])

            edit_hook

            respond_to do |format|
              format.html { render action_path('edit') rescue render 'active_record_controller/edit' }
            end
          end

          # Хук для страницы редактирования сущности
          # Устанавливает хлебную крошку страницы индекса, страницы создания и заголовок страницы по-умолчанию
          define_method(:edit_hook) do
            add_breadcrumb t(:index, scope: plural_resource_name), :"#{plural_resource_name}_path"
            add_breadcrumb t(:edit, scope: plural_resource_name)

            @page_title = t(:edit, scope: plural_resource_name)
          end
        end

        # Определяет экшен create
        def define_create_action
          # POST /object
          # POST /object.json
          define_method(:create) do
            @object = model.new(object_params)

            create_hook

            respond_to do |format|
              if @object.save
                format.html { redirect_to @object, notice: t('common.saved') }
                format.json { render json: { notice: t('common.saved'),
                                             edit_path: send("edit_#{resource_name}_path", @object) },
                                     status: :created,
                                     location: @object }
              else
                format.html { render action: "new" }
                format.json { render json: { errors: @object.errors,
                                             notice: t('common.error') },
                                     status: :unprocessable_entity }
              end
            end
          end

          # Хук для создания сущности
          # По-умолчанию ничего не делает
          define_method(:create_hook) do
          end
        end

        # Определяет экшен update
        def define_update_action
          # PUT /object/1
          # PUT /object/1.json
          define_method(:update) do
            @object = model.find(params[:id])

            respond_to do |format|
              if @object.update(object_params)
                format.html { redirect_to @object, notice: t('common.updated') }
                # format.json { render json: @object }
                format.json { render json: { notice: t('common.updated') } }
              else
                format.html { render action: "edit" }
                format.json { render json: { errors: @object.errors,
                                             notice: t('common.error') },
                                     status: :unprocessable_entity }
              end
            end
          end
        end

        # Определяет экшен destroy
        def define_destroy_action
          # DELETE /object/1
          # DELETE /object/1.json
          define_method(:destroy) do
            @object = model.find(params[:id])
            @object.destroy

            respond_to do |format|
              format.html { redirect_to send("#{plural_resource_name}_url", role: params[:role]) }
              format.json { head :no_content }
            end
          end
        end
      end
    end

    protected

      def object_params
        params.require(resource_name).permit(model.attribute_names(recursive: true))
      end

      def model
        @model ||= resource_name.to_s.classify.constantize
      end

      def plural_resource_name
        @plural_resource_name ||= resource_name.to_s.pluralize
      end

      def action_path(action_name)
        "#{controller_scope}/#{plural_resource_name}/#{action_name}"
      end
  end
end
