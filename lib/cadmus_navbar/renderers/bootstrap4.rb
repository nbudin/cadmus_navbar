module CadmusNavbar
  module Renderers
    class Bootstrap4 < CadmusNavbar::Renderer
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Context

      def render_navigation_section(section, links)
        content_tag(:li, class: 'nav-item dropdown') do
          safe_join([
            content_tag(:a, section.title, class: "nav-link dropdown-toggle", "data-toggle" => "dropdown", role: "button", "aria-haspopup" => "true", "aria-expanded" => "false"),
            content_tag(:div, class: 'dropdown-menu') do
              safe_join(links.map { |item| render_navigation_link(item, root: false) })
            end
          ])
        end
      end

      def render_navigation_link(item, root:)
        is_active = navigation_link_is_active?(item)
        item_class = class_for_navigation_link(root)

        classes = [item_class]
        classes << 'active' if is_active

        link_to url_for_page(item.page), class: classes.join(' ') do
          safe_join(
            [
              item.title,
              (is_active ? content_tag(:span, ' (current)', class: 'sr-only') : nil)
            ].compact
          )
        end
      end

      def class_for_navigation_link(root)
        if root
          'nav-item nav-link'
        else
          'dropdown-item'
        end
      end
    end
  end
end