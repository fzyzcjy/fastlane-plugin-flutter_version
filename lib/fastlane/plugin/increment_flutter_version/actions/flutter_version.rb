# frozen_string_literal: true

require 'fastlane/action'
require 'yaml'
require_relative '../helper/flutter_version_helper'

module Fastlane
  module Actions
    # The top-level plugin interface
    class FlutterVersionAction < Action
      def self.run(params)
        version_info = Helper::FlutterVersionHelper.get_flutter_version(params[:pubspec_location])
        UI.message("Version info: #{version_info}")
        return version_info
      end

      def self.description
        'A plugin to retrieve versioning information for Flutter projects.'
      end

      def self.authors
        ['tianhaoz95']
      end

      def self.return_value
        [
            ['VERSION_CODE', 'The version code'],
            ['VERSION_NAME', 'The verison name']
        ]
      end

      def self.details
        "The plugin reads and parses pubspec.yml of a Flutter
        project and composes the versioning information into
        structured data to be consumed by various releasing
        automations."
      end

      def self.available_options
        [
            Helper::FlutterVersionHelper.get_pubspec_location_config
        ]
      end

      # rubocop:disable Naming/PredicateName
      def self.is_supported?(_platform)
        true
      end
      # rubocop:enable Naming/PredicateName
    end
  end
end
