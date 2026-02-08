# frozen_string_literal: true

module RailsSkills
  module Generators
    module SymlinkSupport
      private

      def create_skill_symlink(skill_name, skill_path)
        RailsSkills::SKILL_TARGETS.each do |target_dir|
          link = File.join(destination_root, target_dir, skill_name)
          if File.symlink?(link) || File.exist?(link)
            say_status :exist, "#{target_dir}/#{skill_name}", :blue
          else
            target_dir_path = File.join(destination_root, target_dir)
            FileUtils.mkdir_p(target_dir_path) unless File.directory?(target_dir_path)
            File.symlink("../../#{skill_path}", link)
            say_status :symlink, "#{target_dir}/#{skill_name} -> ../../#{skill_path}", :green
          end
        end
      end
    end
  end
end
