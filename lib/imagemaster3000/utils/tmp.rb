require 'open-uri'
require 'tempfile'

module Imagemaster3000
  module Utils
    class Tmp
      def self.download(url)
        file = Tempfile.new('imagemaster3000')
        download = open(url)
        logger.debug "Downloading file from url #{url} to tempfile #{file.path.inspect}"
        IO.copy_stream(download, file)

        file.rewind
        file
      end

      def self.destroy(file)
        logger.debug "Closing tempfile #{file.path.inspect}"
        file.close
        file.unlink
      end
    end
  end
end
