# frozen_string_literal: true

namespace :rails_skills do
  desc "Validate YAML frontmatter in all SKILL.md files"
  task :validate do
    require "rails_skills/skill_validator"

    skill_files = Dir.glob("#{RailsSkills::SKILLS_DIR}/**/SKILL.md")

    if skill_files.empty?
      puts "No SKILL.md files found in #{RailsSkills::SKILLS_DIR}/"
      exit 0
    end

    has_errors = false

    skill_files.sort.each do |file|
      errors = RailsSkills::SkillValidator.validate(file)

      if errors.empty?
        puts "  \u2713 #{file}"
      else
        has_errors = true
        puts "  \u2717 #{file}"
        errors.each { |e| puts "    - #{e}" }
      end
    end

    if has_errors
      puts "\nValidation failed."
      exit 1
    else
      puts "\nAll skills valid."
    end
  end
end
