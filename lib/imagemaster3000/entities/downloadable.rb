require 'net/https'

module Imagemaster3000
  module Entities
    module Downloadable
      def download
        logger.debug "Downloading image from #{url.inspect}"

        uri = URI.parse url
        filename = generate_filename
        @local_filename = filename
        @remote_filename = File.basename(uri.path)
        retrieve_image(uri, filename)

        logger.debug "Image from #{url.inspect} was saved as #{filename.inspect}"
        @size = File.size filename
      rescue ::URI::InvalidURIError, ::IOError => ex
        raise Imagemaster3000::Errors::DownloadError, ex
      end

      private

      def retrieve_image(uri, filename)
        use_ssl = uri.scheme == 'https'
        Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
          request = Net::HTTP::Get.new(uri)

          http.request(request) do |response|
            if response.is_a? Net::HTTPRedirection
              retrieve_image URI.join(uri, response.header['location']), filename
              break
            end

            response.value
            File.open(filename, 'w') { |file| response.read_body { |chunk| file.write(chunk) } }
          end
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, Net::HTTPBadResponse,
             Net::HTTPHeaderSyntaxError, EOFError, Net::HTTPServerException, Net::HTTPRetriableError => ex
        raise Imagemaster3000::Errors::DownloadError, ex
      end

      def generate_filename
        File.join(Imagemaster3000::Settings[:'image-dir'], SecureRandom.hex)
      end
    end
  end
end
