module CadmusNavbar
  class Renderer
    include ActionView::Helpers::OutputSafetyHelper

    attr_accessor :request, :current_uri, :root_items

    def initialize(request:, url_for_page:, root_items: nil)
      @_url_for_page = url_for_page
      @request = request
      @current_uri = URI.parse(request.url)
      @root_items = root_items
    end

    def self.from_parent(parent:, **args)
      items = CadmusNavbar.navigation_item_model.where(
        parent_id: parent.id,
        parent_type: parent.class.base_class.name
      ).root.includes(:page, navigation_links: :page)
      self.new(root_items: items.to_a, **args)
    end

    def render_navigation_items
      rendered_items = root_items.sort_by(&:position).map { |item| render_navigation_item(item) }
      safe_join(rendered_items)
    end

    def render_navigation_item(item)
      case item.item_type
      when 'section' then render_navigation_section(item, item.navigation_links.sort_by(&:position))
      when 'link' then render_navigation_link(item, root: true)
      end
    end

    def render_navigation_section(item)
      raise '#render_navigation_section must be implemented by subclasses'
    end

    def render_navigation_link(item, root:)
      raise '#render_navigation_link must be implemented by subclasses'
    end

    def navigation_link_is_active?(item)
      return false unless item && item.page

      page_uri = URI.parse(url_for_page(item.page))
      page_uri.path == current_uri.path
    end

    def url_for_page(page)
      @_url_for_page.call(page)
    end
  end
end