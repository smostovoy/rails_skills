# frozen_string_literal: true

require "rails_skills/version"
require "rails_skills/railtie" if defined?(Rails::Railtie)

module RailsSkills
  class Error < StandardError; end

  SKILLS_DIR = "skills"
  CLAUDE_DIR = ".claude"
  CODEX_DIR = ".codex"
  CATEGORIES = %w[domains stack workflows].freeze
  SKILL_TARGETS = ["#{CLAUDE_DIR}/skills", "#{CODEX_DIR}/skills"].freeze
end
