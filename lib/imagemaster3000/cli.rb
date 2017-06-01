require 'thor'
require 'yell'

module Imagemaster3000
  class CLI < Thor
    class_option :'logging-level',
                 required: true,
                 default: Imagemaster3000::Settings['logging']['level'],
                 type: :string,
                 enum: Yell::Severities
    class_option :'logging-file',
                 default: Imagemaster3000::Settings['logging']['file'],
                 type: :string,
                 desc: 'File to write logs to'
    class_option :debug,
                 default: Imagemaster3000::Settings['debug'],
                 type: :boolean,
                 desc: 'Runs in debug mode'

    method_option :'definitions-dir',
                  default: Imagemaster3000::Settings['definitions-dir'],
                  type: :string,
                  desc: 'If set, definitions in this direcotry are used to download and modify images'
    method_option :'image-dir',
                  default: Imagemaster3000::Settings['image-dir'],
                  type: :string,
                  required: true,
                  desc: 'Directory where to temporarily store images'
    method_option :group,
                  required: true,
                  default: Imagemaster3000::Settings['group'],
                  type: :string,
                  desc: 'Group, images will be uploaded to'
    method_option :'image-list',
                  required: true,
                  default: Imagemaster3000::Settings['image-list'],
                  type: :string,
                  desc: 'Name and path of generated image list'
    method_option :endpoint,
                  required: true,
                  default: Imagemaster3000::Settings['endpoint'],
                  type: :string,
                  desc: 'Endpoint where image list will be available'
    method_option :certificate,
                  required: true,
                  default: Imagemaster3000::Settings['certificate'],
                  type: :string,
                  desc: 'Certificate to sign image list with'
    method_option :key,
                  required: true,
                  default: Imagemaster3000::Settings['key'],
                  type: :string,
                  desc: 'Key to sign image list with'
    method_option :'binaries-virt-copy-in',
                  required: true,
                  default: Imagemaster3000::Settings['binaries']['virt-copy-in'],
                  type: :string,
                  desc: 'Path to binary needed for \'copy\' action'
    method_option :'binaries-guestfish',
                  required: true,
                  default: Imagemaster3000::Settings['binaries']['guestfish'],
                  type: :string,
                  desc: 'Path to binary needed for \'remove\' action'

    desc 'start', 'Downloads images and generates image list'
    def start
      initialize_configuration options
      initialize_logger
      logger.debug "Imagemaster3000 'start' called with parameters: #{Imagemaster3000::Settings.to_hash.inspect}"

      Imagemaster3000::MainProcess.new.run
    end

    desc 'version', 'Prints imagemaster3000 version'
    def version
      $stdout.puts Imagemaster3000::VERSION
    end

    default_task :start

    private

    def initialize_configuration(options)
      Imagemaster3000::Settings.clear
      Imagemaster3000::Settings.merge! options.to_hash

      gem_dir = File.realdirpath(File.join(File.dirname(__FILE__), '..', '..'))
      Imagemaster3000::Settings[:'definitions-dir'] = File.join(gem_dir, 'config', 'definitions') \
        unless Imagemaster3000::Settings[:'definitions-dir']
    end

    def initialize_logger
      Imagemaster3000::Settings[:'logging-level'] = 'DEBUG' if Imagemaster3000::Settings[:debug]

      logging_file = Imagemaster3000::Settings[:'logging-file']
      logging_level = Imagemaster3000::Settings[:'logging-level']

      Yell.new :stdout, name: Object, level: logging_level.downcase, format: Yell::DefaultFormat
      Object.send :include, Yell::Loggable

      setup_file_logger(logging_file) if logging_file

      logger.debug 'Running in debug mode...'
    end

    def setup_file_logger(logging_file)
      unless (File.exist?(logging_file) && File.writable?(logging_file)) || File.writable?(File.dirname(logging_file))
        logger.error "File #{logging_file} isn't writable"
        return
      end

      logger.adapter :file, logging_file
    end
  end
end
