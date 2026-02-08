# frozen_string_literal: true

require "rails/generators"
require_relative "../symlink_support"

module RailsSkills
  module Generators
    class SkillGenerator < Rails::Generators::NamedBase
      include SymlinkSupport

      source_root File.expand_path("templates", __dir__)

      class_option :description, type: :string, default: nil,
                                 desc: "Skill description"
      class_option :with_references, type: :boolean, default: false,
                                     desc: "Create references directory"

      def create_skill_directory
        empty_directory skill_path
      end

      def create_skill_file
        template "SKILL.md.tt", "#{skill_path}/SKILL.md"
      end

      def create_references_directory
        return unless options[:with_references]

        empty_directory "#{skill_path}/references"
        create_file "#{skill_path}/references/.keep", ""
      end

      def create_symlinks
        create_skill_symlink(skill_name, skill_path)
      end

      def show_instructions
        targets = RailsSkills::SKILL_TARGETS.map { |t| "#{t}/#{skill_name}" }.join(" and ")
        say "\nSkill '#{skill_name}' created in #{skill_path}/", :green
        say "Symlinked to #{targets}", :blue
      end

      private

      def skill_path
        "#{RailsSkills::SKILLS_DIR}/#{file_name}"
      end

      def skill_name
        file_name.split("/").last
      end

      def skill_description
        options[:description] || "Custom skill for #{skill_name.tr('-', ' ')}"
      end
    end
  end
end
