# frozen_string_literal: true

require "yaml"

module RailsSkills
  class SkillValidator
    FRONTMATTER_REGEX = /\A---\n(.+?\n)---\n/m

    REQUIRED_KEYS = %w[name description].freeze

    def self.validate(file_path)
      new(file_path).validate
    end

    def self.valid?(file_path)
      validate(file_path).empty?
    end

    def initialize(file_path)
      @file_path = file_path
    end

    def validate
      errors = []

      content = read_file(errors)
      return errors unless content

      frontmatter_text = extract_frontmatter(content, errors)
      return errors unless frontmatter_text

      data = parse_yaml(frontmatter_text, errors)
      return errors unless data

      validate_required_keys(data, errors)

      errors
    end

    private

    def read_file(errors)
      content = File.read(@file_path)
      if content.strip.empty?
        errors << "File is empty"
        return nil
      end
      content
    rescue Errno::ENOENT
      errors << "File not found: #{@file_path}"
      nil
    end

    def extract_frontmatter(content, errors)
      match = content.match(FRONTMATTER_REGEX)
      unless match
        errors << "Missing YAML frontmatter delimiters (---)"
        return nil
      end
      match[1]
    end

    def parse_yaml(text, errors)
      data = YAML.safe_load(text)
      unless data.is_a?(Hash)
        errors << "Frontmatter is not a valid YAML mapping"
        return nil
      end
      data
    rescue Psych::SyntaxError => e
      errors << "Invalid YAML in frontmatter: #{e.message}"
      nil
    end

    def validate_required_keys(data, errors)
      REQUIRED_KEYS.each do |key|
        if !data.key?(key)
          errors << "Missing required key: #{key}"
        elsif data[key].to_s.strip.empty?
          errors << "Value for '#{key}' cannot be empty"
        end
      end
    end
  end
end
