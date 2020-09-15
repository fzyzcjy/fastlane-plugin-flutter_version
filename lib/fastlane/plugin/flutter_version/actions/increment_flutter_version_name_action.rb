# frozen_string_literal: true

require 'fastlane/action'
require 'yaml'
require_relative '../helper/flutter_version_helper'

module Fastlane
  module Actions
    class IncrementFlutterVersionName < Action
      def self.run(params)
        pubspec_location = params[:pubspec_location]
        version_info = Helper::FlutterVersionHelper.get_flutter_version(pubspec_location)
        version_name = version_info['version_name']
        version_code_int = Integer(version_info['version_code'])

        # ref https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/increment_version_number.rb
        version_name_array = current_version.split(".").map { |x| Integer(x) }
        case params[:bump_type]
        when "bump"
          version_name_array[-1] = version_name_array[-1] + 1
        when "patch"
          version_name_array[2] = version_name_array[2] + 1
        when "minor"
          version_name_array[1] = version_name_array[1] + 1
          version_name_array[2] = 0 if version_name_array[2]
        when "major"
          version_name_array[0] = version_name_array[0] + 1
          version_name_array[1] = 0 if version_name_array[1]
          version_name_array[2] = 0 if version_name_array[2]
        else
          raise 'invalid bump type'
        end

        next_version_name = version_name_array.join(".")
        next_version_code = (version_code_int + 1).to_s

        Helper::FlutterVersionHelper.set_flutter_version(pubspec_location, next_version_name, next_version_code)
      end

      def self.description
        'An action to increment the Flutter version name.'
      end

      def self.authors
        ['fzyzcjy']
      end

      def self.available_options
        [
            Helper::FlutterVersionHelper.get_pubspec_location_config,
            # ref: https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/increment_version_number.rb
            FastlaneCore::ConfigItem.new(
                key: :bump_type,
                env_name: "FL_FLUTTER_VERSION_NUMBER_BUMP_TYPE",
                description: "The type of this version bump. Available: patch, minor, major",
                default_value: "bump",
                verify_block: proc do |value|
                  UI.user_error!("Available values are 'patch', 'minor' and 'major'") unless ['bump', 'patch', 'minor', 'major'].include?(value)
                end
            ),
            FastlaneCore::ConfigItem.new(
                key: :version,
                description: 'The version of Flutter',
                optional: true,
                type: String,
            ),
        ]
      end

      def self.is_supported?(_platform)
        true
      end
    end
  end
end
