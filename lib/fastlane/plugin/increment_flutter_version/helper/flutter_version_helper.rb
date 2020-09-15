# frozen_string_literal: true

require 'fastlane_core/ui/ui'

# Fastlane namespace
module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?('UI')

  module Helper
    # Generated helper function for the plugin
    class FlutterVersionHelper
      # class methods that you define here become available in your action
      # as `Helper::FlutterVersionHelper.your_method`
      def self.show_message
        UI.message('Hello from the flutter_version plugin helper!')
      end

      def self.get_flutter_version(pubspec_location)
        begin
          pubspec = YAML.load_file(pubspec_location)
            # rubocop:disable Style/RescueStandardError
        rescue
          raise 'Read pubspec.yaml failed'
        end
        # rubocop:enable Style/RescueStandardError
        version = pubspec['version']
        UI.message('The full version is: '.dup.concat(version))
        unless version.include?('+')
          raise 'Verson code indicator (+) not found in pubspec.yml'
        end

        version_sections = version.split('+')
        version_name = version_sections[0]
        version_code = version_sections[1]

        return {
            'version_code' => version_code,
            'version_name' => version_name
        }
      end

      def self.set_flutter_version(pubspec_location, flutter_version_name, flutter_version_code)
        old_version_info = get_flutter_version(pubspec_location)

        prefix = "version: "
        old_version_str = "#{old_version_info["version_name"]}+#{old_version_info["version_code"]}"
        new_version_str = "#{flutter_version_name}+#{flutter_version_code}"

        old_pubspec = File.read(pubspec_location)
        new_pubspec = old_pubspec.sub "#{prefix}#{old_version_str}", "#{prefix}#{new_version_str}"
        raise 'does not change anything - maybe the format of pubspec is wrong?' unless old_pubspec != new_pubspec
       
        File.write(pubspec_location, new_pubspec)
      end

      def self.get_pubspec_location_config
        return FastlaneCore::ConfigItem.new(
            key: :pubspec_location,
            env_name: 'PUBSPEC_LOCATION',
            description: 'The location of pubspec.yml',
            optional: true,
            type: String,
            default_value: '../pubspec.yaml'
        )
      end
    end
  end
end
