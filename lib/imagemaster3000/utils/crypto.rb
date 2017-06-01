module Imagemaster3000
  module Utils
    class Crypto
      def self.verify_clearsign(file)
        logger.debug "Verifying clearsign signature for file #{file.path.inspect}"
        verify [file], "Verification failed on file #{file.path.inspect}"
      end

      def self.verify_detached(signature, data)
        logger.debug "Verifying detached signature for file #{data.path.inspect} and signature #{signature.path.inspect}"
        verify [signature, { signed_text: data }],
               "Verification failed on file #{data.path.inspect} with signature #{signature.path.inspect}",
               data
      end

      def self.verify(arguments, message, return_value = nil)
        crypto = ::GPGME::Crypto.new
        output = crypto.send(:verify, *arguments) do |signature|
          raise Imagemaster3000::Errors::VerificationError, "#{message}: #{signature}" unless signature.valid?
        end

        output = return_value if return_value
        output.seek 0
        output.read
      end
    end
  end
end
