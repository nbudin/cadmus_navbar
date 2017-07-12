module CadmusNavbar
  module NavigationItem
    extend ActiveSupport::Concern
    include Cadmus::Concerns::ModelWithParent

    module ClassMethods
      def cadmus_navigation_item
        belongs_to :navigation_section, class_name: self.name, inverse_of: :navigation_links, optional: true
        belongs_to :page, class_name: Cadmus.page_model.name, optional: true
        has_many :navigation_links, class_name: self.name, foreign_key: 'navigation_section_id', inverse_of: :navigation_section, dependent: :destroy

        scope :root, -> { where(navigation_section_id: nil) }

        acts_as_list scope: [:parent_type, :parent_id, :navigation_section_id]
      end
    end

    def item_type
      if page || navigation_section
        'link'
      else
        'section'
      end
    end
  end
end