require 'json'
require 'json-schema'

module Imagemaster3000
  module Definitions
    class Parser
      SCHEMA = File.join File.dirname(__FILE__), 'schemas', 'imagemaster3000-definition-schema.json'

      class << self
        def parse_image_definitions
          definition_files = Dir.glob(File.join(Imagemaster3000::Settings[:'definitions-dir'], '*.json')).sort
          logger.debug "Found definition files: #{definition_files.inspect}"
          definition_files.map { |file| parse file }.compact
        end

        private

        def parse(file)
          logger.debug "Parsing file #{file.inspect}"
          json = File.read file
          validate json

          hash = JSON.parse json, symbolize_names: true
          Imagemaster3000::Entities::Image.new hash
        rescue Imagemaster3000::Errors::ArgumentError, Imagemaster3000::Errors::ParsingError => ex
          logger.error "Parsing error occured while reading definition #{file.inspect}: #{ex.message}. Skipping."
          nil
        end

        def validate(json)
          logger.debug "Validating json\n#{json}"
          JSON::Validator.schema_reader = JSON::Schema::Reader.new(accept_uri: false, accept_file: true)
          JSON::Validator.validate!(SCHEMA, json, json: true)
        rescue JSON::Schema::JsonParseError => ex
          raise Imagemaster3000::Errors::ParsingError, ex
        rescue JSON::Schema::ValidationError => ex
          raise Imagemaster3000::Errors::ParsingError, "JSON is not valid according to JSON schema: #{ex.message}"
        end
      end

      private_class_method :parse
      private_class_method :validate
    end
  end
end
