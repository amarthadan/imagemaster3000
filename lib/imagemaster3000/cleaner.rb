module Imagemaster3000
  class Cleaner
    CLEAN_FILE = File.join(Imagemaster3000::Settings[:'image-dir'], 'clean.list')

    class << self
      def clean
        return unless File.exist? CLEAN_FILE

        logger.debug 'Cleaning old images'
        files = File.read(CLEAN_FILE).lines.reject { |line| line =~ /^\s+$/ }.map(&:strip)
        files.each do |file|
          logger.debug "Removing file #{file.inspect}"
          File.delete file if File.exist? file
        end
        File.delete CLEAN_FILE
      end

      def write_clean_file(files)
        clean_data = files.join("\n").concat("\n")
        logger.debug "Writing clean file, new data:\n#{clean_data}"
        File.write CLEAN_FILE, clean_data, mode: 'a'
      end
    end
  end
end
