module Imagemaster3000
  module Entities
    class Image
      include Downloadable

      attr_accessor :name, :url, :distribution, :version, :ram, :cpu, :actions, :verification, :local_filename, :remote_filename, :size

      def initialize(name: nil, url: nil, distribution: nil, version: nil, ram: nil, cpu: nil, actions: nil, verification: nil)
        raise Imagemaster3000::Errors::ArgumentError, 'name, url, distribution or version cannot be nil' \
          if name.blank? || url.blank? || distribution.blank? || version.blank?

        @name = name
        @url = url
        @distribution = distribution
        @version = version
        @ram = ram
        @cpu = cpu
        @actions = prepare_actions actions
        @verification = prepare_verification verification

        logger.debug "Created image #{inspect}"
      end

      private

      def prepare_actions(actions_hash)
        return nil if actions_hash.blank?
        logger.debug 'Preparing actions'

        namespace = Imagemaster3000::Actions
        prepared_actions = []

        actions_hash.each_pair do |action_name, array|
          action_const_name = action_name.capitalize.to_sym
          raise Imagemaster3000::Errors::ActionError, "No such action #{action_name.inspect}" \
            unless namespace.constants.include? action_const_name

          logger.debug "Recognized action #{action_name.inspect}"
          action_const = namespace.const_get action_const_name
          prepared_actions += array.map { |object| action_const.new(object) }
        end

        prepared_actions
      end

      def prepare_verification(verification_hash)
        return nil if verification_hash.blank?
        logger.debug 'Preparing verification'

        extend Imagemaster3000::Verification::Verifiable
        prepared_verification = {}

        prepared_verification[:signature] = prepare_signature_verification verification_hash[:signature]
        prepared_verification[:hash] = prepare_hash_verification verification_hash[:hash]

        prepared_verification
      end

      def prepare_signature_verification(signature_hash)
        logger.debug 'Preparing signature verification'
        namespace = Imagemaster3000::Verification::Signatures
        signature_name = signature_hash.keys.first
        signature_const_name = signature_name.capitalize.to_sym

        raise Imagemaster3000::Errors::VerificationError, "No such signature type #{signature_name}" \
          unless namespace.constants.include? signature_const_name

        logger.debug "Recognized signature #{signature_name}"
        extend namespace.const_get(signature_const_name)

        signature_hash[signature_name]
      end

      def prepare_hash_verification(hash_hash)
        logger.debug 'Preparing hash verification'
        extend Imagemaster3000::Verification::Hash

        hash_function_name = hash_hash[:function]
        hash_function_const_name = hash_function_name.upcase.to_sym

        begin
          Digest(hash_function_const_name)
        rescue LoadError
          raise Imagemaster3000::Errors::VerificationError, "No such hash function #{hash_function_name}"
        end

        logger.debug "Recognized hash function #{hash_function_name}"
        { function: Digest.const_get(hash_function_const_name) }
      end
    end
  end
end
