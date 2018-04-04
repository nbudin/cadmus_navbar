module CadmusNavbar
  class Renderer
    include ActionView::Helpers::OutputSafetyHelper

    attr_accessor :request, :current_uri, :root_items, :items_by_section_id

    def initialize(request:, url_for_page:, items_by_section_id: nil, root_items: nil)
      @_url_for_page = url_for_page
      @request = request
      @current_uri = URI.parse(request.url)
      @items_by_section_id = items_by_section_id

      if !items_by_section_id && root_items
        @items_by_section_id = root_items.flat_map { |item| [item, *item.navigation_links] }
          .group_by(&:navigation_section_id)
      end
    end

    def self.from_parent(parent:, **args)
      items = CadmusNavbar.navigation_item_model.where(
        parent_id: parent.id,
        parent_type: parent.class.base_class.name
      ).root.includes(:page).group_by(&:navigation_section_id)
      self.new(items_by_section_id: items.to_a, **args)
    end

    def root_items
      items_by_section_id[nil]
    end

    def render_navigation_items
      rendered_items = root_items.sort_by(&:position).map { |item| render_navigation_item(item) }
      safe_join(rendered_items)
    end

    def render_navigation_item(item)
      case item.item_type
      when 'section'
        render_navigation_section(item, items_by_section_id[item.id].sort_by(&:position))
      when 'link'
        render_navigation_link(item, root: true)
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
