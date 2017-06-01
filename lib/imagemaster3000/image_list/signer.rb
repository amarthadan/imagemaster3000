require 'openssl'

module Imagemaster3000
  module ImageList
    class Signer
      class << self
        def sign(image_list_data)
          logger.debug "Signing image list with certificate #{Imagemaster3000::Settings[:certificate].inspect} " \
                       "and key #{Imagemaster3000::Settings[:key].inspect}"
          cert = OpenSSL::X509::Certificate.new File.new(Imagemaster3000::Settings[:certificate])
          key = OpenSSL::PKey.read File.new(Imagemaster3000::Settings[:key])
          pkcs7 = OpenSSL::PKCS7.sign cert, key, image_list_data, [], OpenSSL::PKCS7::DETACHED
          OpenSSL::PKCS7.write_smime pkcs7
        end
      end
    end
  end
end
