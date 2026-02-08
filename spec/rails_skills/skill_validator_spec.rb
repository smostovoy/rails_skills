# frozen_string_literal: true

require "spec_helper"
require "tmpdir"
require "fileutils"

RSpec.describe RailsSkills::SkillValidator do
  let(:tmp_dir) { Dir.mktmpdir }
  let(:file_path) { File.join(tmp_dir, "SKILL.md") }

  after { FileUtils.rm_rf(tmp_dir) }

  def write_skill(content)
    File.write(file_path, content)
  end

  describe ".validate" do
    context "with valid frontmatter" do
      it "returns no errors" do
        write_skill(<<~MD)
          ---
          name: my-skill
          description: A useful skill
          ---

          # My Skill
        MD

        expect(described_class.validate(file_path)).to be_empty
      end

      it "returns no errors with extra keys" do
        write_skill(<<~MD)
          ---
          name: my-skill
          description: A useful skill
          version: 1.0.0
          ---

          # My Skill
        MD

        expect(described_class.validate(file_path)).to be_empty
      end
    end

    context "with missing frontmatter delimiters" do
      it "returns an error" do
        write_skill(<<~MD)
          name: my-skill
          description: A useful skill

          # My Skill
        MD

        errors = described_class.validate(file_path)
        expect(errors).to include("Missing YAML frontmatter delimiters (---)")
      end
    end

    context "with missing name key" do
      it "returns an error" do
        write_skill(<<~MD)
          ---
          description: A useful skill
          ---

          # My Skill
        MD

        errors = described_class.validate(file_path)
        expect(errors).to include("Missing required key: name")
      end
    end

    context "with missing description key" do
      it "returns an error" do
        write_skill(<<~MD)
          ---
          name: my-skill
          ---

          # My Skill
        MD

        errors = described_class.validate(file_path)
        expect(errors).to include("Missing required key: description")
      end
    end

    context "with empty name value" do
      it "returns an error" do
        write_skill(<<~MD)
          ---
          name: ""
          description: A useful skill
          ---

          # My Skill
        MD

        errors = described_class.validate(file_path)
        expect(errors).to include("Value for 'name' cannot be empty")
      end
    end

    context "with empty description value" do
      it "returns an error" do
        write_skill(<<~MD)
          ---
          name: my-skill
          description: ""
          ---

          # My Skill
        MD

        errors = described_class.validate(file_path)
        expect(errors).to include("Value for 'description' cannot be empty")
      end
    end

    context "with an empty file" do
      it "returns an error" do
        write_skill("")

        errors = described_class.validate(file_path)
        expect(errors).to include("File is empty")
      end
    end

    context "with a whitespace-only file" do
      it "returns an error" do
        write_skill("   \n  \n")

        errors = described_class.validate(file_path)
        expect(errors).to include("File is empty")
      end
    end

    context "with a nonexistent file" do
      it "returns an error" do
        errors = described_class.validate("/nonexistent/SKILL.md")
        expect(errors).to include("File not found: /nonexistent/SKILL.md")
      end
    end
  end

  describe ".valid?" do
    it "returns true for valid frontmatter" do
      write_skill(<<~MD)
        ---
        name: my-skill
        description: A useful skill
        ---

        # My Skill
      MD

      expect(described_class.valid?(file_path)).to be true
    end

    it "returns false for invalid frontmatter" do
      write_skill("")

      expect(described_class.valid?(file_path)).to be false
    end
  end
end
