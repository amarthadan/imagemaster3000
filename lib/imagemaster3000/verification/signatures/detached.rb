module Imagemaster3000
  module Verification
    module Signatures
      module Detached
        def verify_signature!
          signature_tmp_file = Imagemaster3000::Utils::Tmp.download verification[:signature][:signature]
          data_tmp_file = Imagemaster3000::Utils::Tmp.download verification[:signature][:data]
          verification[:hash][:list] = Imagemaster3000::Utils::Crypto.verify_detached signature_tmp_file, data_tmp_file
        rescue ::GPGME::Error => ex
          raise Imagemaster3000::Errors::VerificationError, ex
        ensure
          Imagemaster3000::Utils::Tmp.destroy signature_tmp_file
          Imagemaster3000::Utils::Tmp.destroy data_tmp_file
        end
      end
    end
  end
end
