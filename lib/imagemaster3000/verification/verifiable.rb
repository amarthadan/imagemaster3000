module Imagemaster3000
  module Verification
    module Verifiable
      def verify!
        verify_signature!
        verify_hash!
      end
    end
  end
end
