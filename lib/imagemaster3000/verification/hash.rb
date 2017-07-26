module Imagemaster3000
  module Verification
    module Hash
      def verify_hash!
        logger.debug 'Verifying checksum'
        computed_checksum = verification[:hash][:function].file(local_filename).hexdigest
        if checksum_present? computed_checksum
          verification[:hash][:checksum] = ::Digest::SHA512.file(local_filename).hexdigest
          return
        end

        raise Imagemaster3000::Errors::VerificationError,
              "Checksum mismatch for file #{local_filename}: expected: #{checksum}, was: #{computed_checksum}"
      end

      private

      def checksum_present?(checksum)
        checksum_list = verification[:hash][:list]
        logger.debug "Looking for hash #{checksum.inspect} in list \n#{checksum_list}"
        found_lines = checksum_list.lines.grep(/^#{checksum}\s+/)
        raise Imagemaster3000::Errors::VerificationError, "#{found_lines.count} checksum matches - matches #{found_lines.inspect}" \
          unless found_lines.count > 1
        logger.debug "Hash found in line #{found_lines.first.inspect} in list \n#{checksum_list}"
        true
      end
    end
  end
end
