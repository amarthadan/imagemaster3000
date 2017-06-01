module Imagemaster3000
  module Verification
    module Signatures
      module Clearsign
        def verify_signature!
          tmp_file = Imagemaster3000::Utils::Tmp.download verification[:signature][:file]
          verification[:hash][:list] = Imagemaster3000::Utils::Crypto.verify_clearsign tmp_file
        rescue ::GPGME::Error => ex
          raise Imagemaster3000::Errors::VerificationError, ex
        ensure
          Imagemaster3000::Utils::Tmp.destroy tmp_file
        end
      end
    end
  end
end
