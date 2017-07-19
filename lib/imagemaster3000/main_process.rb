module Imagemaster3000
  class MainProcess
    attr_accessor :definitions
    attr_accessor :images

    def run
      process_definitions
      process_images
      generate_image_list
      Imagemaster3000::Cleaner.clean
    ensure
      Imagemaster3000::Cleaner.write_clean_file images.map(&:local_filename) if images
      definitions.clean if definitions
    end

    private

    def process_definitions
      @definitions = Imagemaster3000::Definitions::Downloader.download_definitions
      Imagemaster3000::Settings['definitions-dir'] = definitions.path
      logger.debug 'Loading images from definitions'
      @images = Imagemaster3000::Definitions::Parser.parse_image_definitions
    end

    def process_images
      logger.debug 'Processing images'
      images.each do |image|
        logger.debug "Processing image #{image.name.inspect}"
        image.download
        image.verify! if image.respond_to? :verify!
        image.actions.each { |action| action.run image.local_filename } unless image.actions.blank?
      end
    end

    def generate_image_list
      logger.debug 'Generating image list'
      image_list = Imagemaster3000::ImageList::Signer.sign(Imagemaster3000::ImageList::Generator.generate(images))
      File.write Imagemaster3000::Settings[:'image-list'], image_list
    end
  end
end
