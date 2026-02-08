# Rails Skills

[![Gem Version](https://badge.fury.io/rb/rails_skills.svg)](https://badge.fury.io/rb/rails_skills)
[![CI](https://github.com/smostovoy/rails_skills/actions/workflows/ci.yml/badge.svg)](https://github.com/smostovoy/rails_skills/actions/workflows/ci.yml)

Organize your docs into Skills shared between **Humans** and **Agents**.
Main features:
* Organizes all your docs into a format that can be used by Claude Code and Codex - Agent Skills. Read here for [claude](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) and [codex](https://developers.openai.com/codex/skills/)
* Auto-updates docs and guides. If your team or agents trigger a commit from an agent chat, then the `workflows/commit` skill is triggered and checks the diff for needed skill updates.
* Validates skills on CI or locally. 

# Structure
It introduces additional layer on top of MVC - intelligence layer. This layer is optimised for reading by both humans and agents.
The gem scaffolds three default categories but any folder under `skills/` is automatically discovered and symlinked:
| Category | Purpose | Example |
|----------|---------|---------|
| **services/** | Business service skills | `services/payments`, `services/auth` |
| **stack/** | Technology stack skills | `stack/ruby`, `stack/postgres` |
| **workflows/** | Development workflows and guides | `workflows/commit`, `workflows/deploy` |
| **your_folder/** | Any custom category you create | `your_folder/my_skill` |

## Usage

### Install
```ruby
gem "rails_skills"
```
```bash
bundle install
rails generate rails_skills:install
```

### What it creates

```
your_rails_app/
├── skills/                    # Shared AI skill files (canonical location)
│   ├── services/               # Domain-specific skills
│   │   └── .keep
│   ├── stack/                 # Technology stack skills (ruby, rails_skills)
│   │   ├── ruby/
│   │   │   └── SKILL.md
│   │   └── rails_skills/
│   │       └── SKILL.md
│   └── workflows/             # Workflows and guides (commit)
│       └── commit/
│           └── SKILL.md
├── .claude/
│   └── skills/                # Flattened symlinks
│       ├── ruby -> ../../skills/stack/ruby
│       ├── commit -> ../../skills/workflows/commit
│       └── rails_skills -> ../../skills/stack/rails_skills

└── .codex/
    └── skills/                # Flattened symlinks
        ├── ruby -> ../../skills/stack/ruby
        ├── commit -> ../../skills/workflows/commit
        └── rails_skills -> ../../skills/stack/rails_skills
```

Skills are organized by category in `skills/` but flattened when symlinked into `.claude/skills` and `.codex/skills`, because nested dirs are not supported by Claude and Codex.

### Create a custom skill

```bash
rails generate rails_skills:skill services/payments
rails generate rails_skills:skill stack/postgres
rails generate rails_skills:skill workflows/deploy --description="Deployment workflow"
rails generate rails_skills:skill my_folder/my_skill  # custom folders work too
```

Skills are created in `skills/` and automatically symlinked (flattened) into both `.claude/skills` and `.codex/skills`.

## Default Skills

The gem ships with these default skills:

- **stack/ruby** - Ruby language patterns, idioms, and best practices. You can reference Rubocop here.
- **stack/rails_skills** - How to manage skills with the rails_skills gem.
- **workflows/commit** - Git commit workflow to automatically update documentation on each commit.

## How It Works

1. `skills/` is the single source of truth — any subfolder is a category
2. Claude and Codex require a flat skills directory — nested paths are not loaded
3. The gem creates flattened symlinks: `skills/stack/ruby` → `.claude/skills/ruby`
4. Edit skills in `skills/` and both AI tools see the changes immediately
5. New skills created via the generator are automatically symlinked

## CI and Validation

Every `SKILL.md` must include YAML frontmatter with `name` and `description` keys:

```markdown
---
name: my-skill
description: What this skill teaches
---
```

Validate all skills locally:

```bash
bin/rails rails_skills:validate
```

Add the task to your CI pipeline to catch missing or malformed frontmatter:

```yaml
# .github/workflows/ci.yml
- name: Validate skills
  run: bin/rails rails_skills:validate
```

## License

MIT License. See [LICENSE](LICENSE) for details.
