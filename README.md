# RailsSkills

A Ruby gem that organizes AI skills for Rails projects, shared between **Claude** and **Codex**.

RailsSkills creates a `skills/` directory in your Rails root as the canonical location for AI skill definitions, then symlinks it into `.claude/skills` and `.codex/skills` so both AI assistants share the same knowledge base.

## Installation

Add to your Gemfile:

```ruby
gem "rails_skills"
```

Then run:

```bash
bundle install
```

## Usage

### Install

```bash
rails generate rails_skills:install
```

### What it creates

```
your_rails_app/
├── skills/                    # Shared AI skill files (canonical location)
│   ├── domains/               # Domain-specific skills
│   │   └── .keep
│   ├── stack/                 # Technology stack skills
│   │   └── ruby/
│   │       └── SKILL.md
│   └── workflows/             # Workflow skills
│       ├── commit/
│       │   └── SKILL.md
│       └── cli/
│           └── SKILL.md
├── .claude/
│   ├── skills -> ../skills    # Symlink to shared skills
│   ├── agents/
│   ├── commands/
│   ├── rules/
│   └── settings.local.json
└── .codex/
    └── skills -> ../skills    # Symlink to shared skills
```

Both Claude and Codex read from the same `skills/` directory via symlinks.

### Skill Categories

| Category | Purpose | Example |
|----------|---------|---------|
| **domains/** | Business domain knowledge | `domains/payments`, `domains/auth` |
| **stack/** | Technology stack skills | `stack/ruby`, `stack/postgres` |
| **workflows/** | Development workflows | `workflows/commit`, `workflows/cli` |

### Create a custom skill

```bash
rails generate rails_skills:skill domains/payments
rails generate rails_skills:skill stack/postgres
rails generate rails_skills:skill workflows/deploy --description="Deployment workflow"
```

Skills are created in `skills/` and automatically available to both Claude and Codex.

## Default Skills

The gem ships with these pre-built skills:

- **stack/ruby** - Ruby language patterns, idioms, and best practices
- **workflows/commit** - Git commit workflow and conventions
- **workflows/cli** - Command-line workflows for Rails development

## How It Works

1. `skills/` is the single source of truth for AI skill files
2. `.claude/skills` is a symlink pointing to `../skills`
3. `.codex/skills` is a symlink pointing to `../skills`
4. Edit skills in `skills/` and both AI tools see the changes immediately

## License

MIT License. See [LICENSE](LICENSE) for details.
