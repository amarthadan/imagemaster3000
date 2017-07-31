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
              "Not exactly one checksum found for file #{local_filename}: expected: #{computed_checksum}"
      end

      private

      def checksum_present?(checksum)
        checksum_list = verification[:hash][:list]
        logger.debug "Looking for hash #{checksum.inspect} in list \n#{checksum_list}"
        found_lines = checksum_list.lines.grep(/^#{checksum}\s+/)
        logger.debug "#{found_lines.count} checksum matches"
        logger.debug " List of matching lines: #{found_lines.inspect}" if found_lines.count > 0
        found_lines.count == 1
      end
    end
  end
end
