require 'acts_as_list'

require "cadmus_navbar/version"

require "cadmus"
require "cadmus_navbar/engine"

module CadmusNavbar
  extend Cadmus::Concerns::OtherClassAccessor
  other_class_accessor :navigation_item_model

  extend ActiveSupport::Autoload
  autoload :AdminController
  autoload :NavigationItem
  autoload :Renderer
  autoload :Renderers
end
