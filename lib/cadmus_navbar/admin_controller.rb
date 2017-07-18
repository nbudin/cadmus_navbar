module CadmusNavbar
  module AdminController
    extend ActiveSupport::Concern
    include Cadmus::Concerns::ControllerWithParent

    included do
      before_action :load_parent_and_navigation_item
    end

    def index
      respond_to do |format|
        format.html { render template: 'cadmus/navigation_items/index' }
        format.json do
          render json: {
            navigation_items: navigation_item_scope,
            csrf_token: (protect_against_forgery? ? form_authenticity_token: nil)
          }
        end
      end
    end

    def create
      @navigation_item = navigation_item_scope.new(navigation_item_params)

      if @navigation_item.save
        render json: { navigation_item: @navigation_item }, status: :created
      else
        render json: { errors: @navigation_item.errors }, status: :not_acceptable
      end
    end

    def update
      if @navigation_item.update_attributes(navigation_item_params)
        render json: { navigation_item: @navigation_item }, status: :accepted
      else
        render json: { errors: @navigation_item.errors }, status: :not_acceptable
      end
    end

    def destroy
      @navigation_item.destroy
      head :ok
    end

    def sort
      navigation_item_sort_params.each do |item_params|
        navigation_item_scope.where(id: item_params[:id]).update_all(item_params.to_h.except(:id))
      end

      head :ok
    end

    protected

    def navigation_item_scope
      @navigation_item_scope ||= parent_model ? parent_model.navigation_items : CadmusNavbar.navigation_item_model.global
    end

    def navigation_item_params
      params.require(:navigation_item).permit(:parent_id, :title, :page_id, :navigation_section_id)
    end

    def navigation_item_sort_params
      params.require(:navigation_items).map { |item_params| item_params.permit(:id, :position, :navigation_section_id) }
    end

    def load_parent_and_navigation_item
      if params[:id]
        @navigation_item = navigation_item_scope.find(params[:id])
      end
    end
  end
end