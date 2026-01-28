# frozen_string_literal: true

require "rails/generators"

module RailsSkills
  module Generators
    class SkillGenerator < Rails::Generators::NamedBase
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

      def show_instructions
        say "\nSkill '#{file_name}' created in #{skill_path}/", :green
        say "This skill is available to both Claude and Codex via symlinks.", :blue
      end

      private

      def skill_path
        "skills/#{file_name}"
      end

      def skill_description
        options[:description] || "Custom skill for #{file_name.tr('-', ' ')}"
      end
    end
  end
end
