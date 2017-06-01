require 'openssl'
require 'tilt'
require 'erb'

module Imagemaster3000
  module ImageList
    class Generator
      class << self
        def generate(images)
          template_file = File.join(File.dirname(__FILE__), 'templates', 'image_list.erb')
          raise Imagemaster3000::Errors::ArgumentError, 'Missing image list template file' unless File.exist?(template_file)

          logger.debug "Populating template from #{template_file}"

          template = Tilt::ERBTemplate.new template_file, trim: '-'
          rendered = template.render Object.new, images: images

          logger.debug "Image list:\n#{rendered}"

          rendered
        end
      end
    end
  end
end
