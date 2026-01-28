# frozen_string_literal: true

module RailsSkills
  class Railtie < ::Rails::Railtie
    generators do
      require "generators/rails_skills/install/install_generator"
      require "generators/rails_skills/skill/skill_generator"
    end
  end
end
