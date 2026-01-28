# frozen_string_literal: true

require "rails/generators"

module RailsSkills
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      class_option :preset, type: :string, default: "basic",
                            desc: "Preset bundle (basic, fullstack, api)"
      class_option :skip_agents, type: :boolean, default: false,
                                 desc: "Don't create default agents"

      def create_skills_directory
        empty_directory "skills"
      end

      def create_claude_directory
        empty_directory ".claude"
        empty_directory ".claude/commands"
        empty_directory ".claude/rules"
        empty_directory ".claude/agents" unless options[:skip_agents]
      end

      def create_codex_directory
        empty_directory ".codex"
      end

      def create_symlinks
        create_symlink(".claude/skills", "../skills")
        create_symlink(".codex/skills", "../skills")
      end

      def copy_claude_settings
        template "settings.local.json.tt", ".claude/settings.local.json"
      end

      def install_preset_skills
        case options[:preset]
        when "fullstack"
          install_fullstack_preset
        when "api"
          install_api_preset
        else
          install_basic_preset
        end
      end

      def show_instructions
        say ""
        say "RailsSkills installed successfully!", :green
        say ""
        say "Directory structure:", :yellow
        say "  skills/           <- shared AI skill files (canonical location)"
        say "  .claude/skills    -> ../skills (symlink)"
        say "  .codex/skills     -> ../skills (symlink)"
        say ""
        say "Both Claude and Codex now share the same skills from skills/", :blue
        say ""
        say "Next steps:", :yellow
        say "  rails g rails_skills:skill my_skill   # Create a custom skill"
        say ""
      end

      private

      def create_symlink(link_path, target)
        dest = File.join(destination_root, link_path)
        if File.symlink?(dest) || File.exist?(dest)
          say_status :exist, link_path, :blue
        else
          File.symlink(target, dest)
          say_status :symlink, "#{link_path} -> #{target}", :green
        end
      end

      def install_basic_preset
        say "Installing basic preset...", :green
        install_skill("rails-models")
        install_skill("rails-controllers")
        install_skill("rails-views")
        install_rule("code-style")
        install_rule("testing")
        install_command("quality")
        create_basic_agent unless options[:skip_agents]
      end

      def install_fullstack_preset
        say "Installing fullstack preset...", :green
        install_skill("rails-models")
        install_skill("rails-controllers")
        install_skill("rails-views")
        install_skill("rails-hotwire")
        install_skill("rspec-testing")
        install_rule("code-style")
        install_rule("testing")
        install_rule("security")
        install_command("quality")
        create_fullstack_agent unless options[:skip_agents]
      end

      def install_api_preset
        say "Installing API preset...", :green
        install_skill("rails-models")
        install_skill("rails-api-controllers")
        install_skill("rspec-testing")
        install_rule("code-style")
        install_rule("testing")
        install_rule("security")
        install_command("quality")
        create_api_agent unless options[:skip_agents]
      end

      def install_skill(skill_name)
        skill_dir = "skills/#{skill_name}"
        empty_directory skill_dir

        skill_source = File.expand_path("../skills_library/#{skill_name}", __dir__)
        if File.directory?(skill_source)
          directory skill_source, skill_dir
        else
          create_file "#{skill_dir}/SKILL.md", default_skill_content(skill_name)
        end
      end

      def install_rule(rule_name)
        rule_file = ".claude/rules/#{rule_name}.md"
        rule_source = File.expand_path("../rules_library/#{rule_name}.md", __dir__)

        if File.exist?(rule_source)
          copy_file rule_source, rule_file
        else
          create_file rule_file, default_rule_content(rule_name)
        end
      end

      def install_command(command_name)
        command_file = ".claude/commands/#{command_name}.md"
        command_source = File.expand_path("../commands_library/#{command_name}.md", __dir__)

        if File.exist?(command_source)
          copy_file command_source, command_file
        else
          create_file command_file, default_command_content(command_name)
        end
      end

      def create_basic_agent
        template "agents/rails-developer.md.tt", ".claude/agents/rails-developer.md"
      end

      def create_fullstack_agent
        template "agents/fullstack-dev.md.tt", ".claude/agents/fullstack-dev.md"
      end

      def create_api_agent
        template "agents/api-dev.md.tt", ".claude/agents/api-dev.md"
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
