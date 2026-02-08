# frozen_string_literal: true

require "spec_helper"
require "tmpdir"
require "fileutils"

RSpec.describe "Skill validation end-to-end" do
  let(:tmp_dir) { Dir.mktmpdir }

  after { FileUtils.rm_rf(tmp_dir) }

  def skill_dir(name)
    dir = File.join(tmp_dir, "skills", name)
    FileUtils.mkdir_p(dir)
    dir
  end

  context "with a valid SKILL.md" do
    it "validates successfully" do
      dir = skill_dir("my-skill")
      File.write(File.join(dir, "SKILL.md"), <<~MD)
        ---
        name: my-skill
        description: A useful skill
        version: 1.0.0
        ---

        # My Skill

        Some content here.
      MD

      errors = RailsSkills::SkillValidator.validate(File.join(dir, "SKILL.md"))
      expect(errors).to be_empty
    end
  end

  context "with an invalid SKILL.md" do
    it "returns errors for missing fields" do
      dir = skill_dir("bad-skill")
      File.write(File.join(dir, "SKILL.md"), <<~MD)
        ---
        version: 1.0.0
        ---

        # Bad Skill
      MD

      errors = RailsSkills::SkillValidator.validate(File.join(dir, "SKILL.md"))
      expect(errors).to include("Missing required key: name")
      expect(errors).to include("Missing required key: description")
    end
  end

  context "with a generator-style SKILL.md" do
    it "validates a skill matching the generator template" do
      dir = skill_dir("workflows/generated")
      File.write(File.join(dir, "SKILL.md"), <<~MD)
        ---
        name: generated
        description: Custom skill for generated
        version: 1.0.0
        ---

        # Generated

        ## Quick Reference

        | Command | Purpose |
        |---------|---------|
        | TODO    | Add commands here |

        ## Overview

        Custom skill for generated

        ## Usage

        Add usage examples and patterns here.
      MD

      errors = RailsSkills::SkillValidator.validate(File.join(dir, "SKILL.md"))
      expect(errors).to be_empty
    end
  end
end
