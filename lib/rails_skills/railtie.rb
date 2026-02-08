# frozen_string_literal: true

module RailsSkills
  class Railtie < ::Rails::Railtie
    generators do
      require "generators/rails_skills/install/install_generator"
      require "generators/rails_skills/skill/skill_generator"
    end

    rake_tasks do
      load "rails_skills/tasks/skills.rake"
    end
  end
end
