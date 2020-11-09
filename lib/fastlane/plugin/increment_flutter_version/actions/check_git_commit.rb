# frozen_string_literal: true

require 'fastlane/action'
require 'yaml'
require_relative '../helper/flutter_version_helper'

module Fastlane
  module Actions
    class CheckGitCommitAction < Action
      def self.run(params)
        expect_regex = params[:expect_regex]

        # NOTE 1. read last commit message
        git_last_commit_log = Actions.sh('git --no-pager log -n1 --pretty=%B')
        UI.message("git_last_commit_log=#{git_last_commit_log}")
        unless expect_regex.match?(git_last_commit_log)
          UI.user_error!("Unexpected git last commit log. Should be `#{expect_regex}` but found `#{git_last_commit_log}`.")
        end

        # NOTE 2. check the working dir is not dirty
        # copy from: commit_version_bump
        git_dirty_files = Actions.sh('git diff --name-only HEAD').split("\n") + Actions.sh('git ls-files --other --exclude-standard').split("\n")
        if git_dirty_files.length > 0
          UI.user_error!("Found unexpected uncommitted changes in the working directory. git_dirty_files=#{git_dirty_files}")
        end

        UI.success("pass check_git_commit checkers.")
      end

      def self.authors
        ['fzyzcjy']
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(
                key: :expect_regex,
                is_string: false,
            ),
        ]
      end

      def self.is_supported?(_platform)
        true
      end
    end
  end
end
