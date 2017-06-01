module Imagemaster3000
  class MainProcess
    def run
      logger.debug 'Loading images from definitions'
      images = Imagemaster3000::Definitions::Parser.parse_image_definitions
      logger.debug 'Processing images'
      images.each { |image| process_image image }

      logger.debug 'Generating image list'
      image_list = Imagemaster3000::ImageList::Signer.sign(Imagemaster3000::ImageList::Generator.generate(images))
      File.write Imagemaster3000::Settings[:'image-list'], image_list
    end

    private

    def process_image(image)
      image.download
      image.verify! if image.respond_to? :verify!
      image.actions.each { |action| action.run image.file } unless image.actions.blank?
    end
  end
end
