module Imagemaster3000
  module Verification
    module Hash
      def verify_hash!
        logger.debug 'Verifying checksum'
        checksum = find_checksum!
        computed_checksum = verification[:hash][:function].file(local_filename).hexdigest

        if checksum == computed_checksum
          verification[:hash][:checksum] = ::Digest::SHA512.file(local_filename).hexdigest
          return
        end

        raise Imagemaster3000::Errors::VerificationError,
              "Checksum mismatch for file #{local_filename}: expected: #{checksum}, was: #{computed_checksum}"
      end

      private

      def find_checksum!
        split_checksum find_checksum_line
      end

      def find_checksum_line
        checksum_list = verification[:hash][:list]
        filename = remote_filename

        logger.debug "Looking for filename #{filename.inspect} in list \n#{checksum_list}"

        found_lines = checksum_list.lines.grep(/\s+#{filename}\s*$/)
        raise Imagemaster3000::Errors::VerificationError, "Cannot identify checksum for file #{file.inspect}" \
          unless found_lines.count == 1

        checksum_line = found_lines.first
        logger.debug "Found matching line #{checksum_line.inspect}"

        checksum_line
      end

      def split_checksum(checksum_line)
        checksum_line.split.first
      end
    end
  end
end
