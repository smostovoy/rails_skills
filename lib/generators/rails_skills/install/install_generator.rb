# frozen_string_literal: true

require "rails/generators"
require_relative "../symlink_support"

module RailsSkills
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include SymlinkSupport

      source_root File.expand_path("templates", __dir__)

      class_option :skip_agents, type: :boolean, default: false,
                                 desc: "Don't create default agents"

      def create_skills_directory
        empty_directory RailsSkills::SKILLS_DIR
        RailsSkills::CATEGORIES.each do |category|
          empty_directory "#{RailsSkills::SKILLS_DIR}/#{category}"
        end
      end

      def create_claude_directory
        empty_directory RailsSkills::CLAUDE_DIR
        empty_directory "#{RailsSkills::CLAUDE_DIR}/commands"
        empty_directory "#{RailsSkills::CLAUDE_DIR}/rules"
        empty_directory "#{RailsSkills::CLAUDE_DIR}/agents" unless options[:skip_agents]
      end

      def create_codex_directory
        empty_directory RailsSkills::CODEX_DIR
      end

      def create_skills_targets
        RailsSkills::SKILL_TARGETS.each { |target| empty_directory target }
      end

      def copy_claude_settings
        template "settings.local.json.tt", "#{RailsSkills::CLAUDE_DIR}/settings.local.json"
      end

      def install_default_skills
        # domains - empty with .keep
        install_skill_folder("domains")

        # stack - ruby skill
        install_skill("stack/ruby")

        # workflows - commit, rails_skills skills
        install_skill("workflows/commit")
        install_skill("workflows/rails_skills")
      end

      def link_skills
        skills_root = File.join(destination_root, RailsSkills::SKILLS_DIR)

        RailsSkills::CATEGORIES.each do |category|
          category_dir = File.join(skills_root, category)
          next unless File.directory?(category_dir)

          Dir.children(category_dir).sort.each do |name|
            next unless File.directory?(File.join(category_dir, name))
            next if name.start_with?(".")

            create_skill_symlink(name, "#{RailsSkills::SKILLS_DIR}/#{category}/#{name}")
          end
        end
      end

      def install_rules_and_commands
        install_rule("code-style")
        install_rule("testing")
        install_command("quality")
      end

      def create_default_agent
        return if options[:skip_agents]

        template "agents/rails-developer.md.tt", "#{RailsSkills::CLAUDE_DIR}/agents/rails-developer.md"
      end

      def show_instructions
        say ""
        say "RailsSkills installed successfully!", :green
        say ""
        say "Directory structure:", :yellow
        say "  skills/"
        say "    domains/       <- domain-specific skills"
        say "    stack/         <- technology stack skills (ruby)"
        say "    workflows/     <- workflow skills (commit)"
        RailsSkills::SKILL_TARGETS.each do |target|
          say "  #{target}/"
          say "    ruby/          -> ../../skills/stack/ruby"
          say "    commit/        -> ../../skills/workflows/commit"
          say "    rails_skills/  -> ../../skills/workflows/rails_skills"
        end
        say ""
        say "Skills are flattened into #{RailsSkills::SKILL_TARGETS.join(' and ')}", :blue
        say ""
        say "Next steps:", :yellow
        say "  rails g rails_skills:skill domains/my_domain   # Create a domain skill"
        say "  rails g rails_skills:skill stack/postgres      # Create a stack skill"
        say "  rails g rails_skills:skill workflows/deploy    # Create a workflow skill"
        say ""
      end

      private

      def install_skill_folder(folder_name)
        skill_source = File.expand_path("../skills_library/#{folder_name}", __dir__)
        if File.directory?(skill_source)
          directory skill_source, "#{RailsSkills::SKILLS_DIR}/#{folder_name}"
        end
      end

      def install_skill(skill_path)
        skill_dir = "#{RailsSkills::SKILLS_DIR}/#{skill_path}"
        empty_directory skill_dir

        skill_source = File.expand_path("../skills_library/#{skill_path}", __dir__)
        if File.directory?(skill_source)
          directory skill_source, skill_dir
        else
          create_file "#{skill_dir}/SKILL.md", default_skill_content(skill_path.split("/").last)
        end
      end

      def install_rule(rule_name)
        rule_file = "#{RailsSkills::CLAUDE_DIR}/rules/#{rule_name}.md"
        rule_source = File.expand_path("../rules_library/#{rule_name}.md", __dir__)

        if File.exist?(rule_source)
          copy_file rule_source, rule_file
        else
          create_file rule_file, default_rule_content(rule_name)
        end
      end

      def install_command(command_name)
        command_file = "#{RailsSkills::CLAUDE_DIR}/commands/#{command_name}.md"
        command_source = File.expand_path("../commands_library/#{command_name}.md", __dir__)

        if File.exist?(command_source)
          copy_file command_source, command_file
        else
          create_file command_file, default_command_content(command_name)
        end
      end

      def default_skill_content(skill_name)
        <<~SKILL
          ---
          name: #{skill_name}
          description: #{skill_name.tr('-', ' ').capitalize} skill
          version: 1.0.0
          ---

          # #{skill_name.tr('-', ' ').capitalize}

          Add your skill content here.
        SKILL
      end

      def default_rule_content(rule_name)
        <<~RULE
          # #{rule_name.tr('-', ' ').capitalize} Rules

          Add your project rules and guidelines here.
        RULE
      end

      def default_command_content(command_name)
        <<~COMMAND
          ---
          description: #{command_name.tr('-', ' ').capitalize} command
          allowed-tools: Bash, Read, Edit, Write
          ---

          ## #{command_name.tr('-', ' ').capitalize}

          Add your command instructions here.

          Use $ARGUMENTS to reference command arguments.
        COMMAND
      end

      def app_name
        Rails.application.class.module_parent_name
      rescue StandardError
        "MyApp"
      end

      def rails_version
        Rails::VERSION::STRING
      rescue StandardError
        "7.0"
      end
    end
  end
end
