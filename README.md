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

### Install with default (basic) preset

```bash
rails generate rails_skills:install
```

### Install with a preset

```bash
rails generate rails_skills:install --preset=basic
rails generate rails_skills:install --preset=fullstack
rails generate rails_skills:install --preset=api
```

### What it creates

```
your_rails_app/
├── skills/                    # Shared AI skill files (canonical location)
│   ├── rails-models/
│   │   └── SKILL.md
│   ├── rails-controllers/
│   │   └── SKILL.md
│   └── rails-views/
│       └── SKILL.md
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

### Presets

| Preset | Skills included |
|--------|----------------|
| **basic** | rails-models, rails-controllers, rails-views |
| **fullstack** | basic + rails-hotwire, rspec-testing |
| **api** | rails-models, rails-api-controllers, rspec-testing |

### Create a custom skill

```bash
rails generate rails_skills:skill my_custom_skill
rails generate rails_skills:skill my_custom_skill --description="My skill description"
rails generate rails_skills:skill my_custom_skill --with-references
```

Skills are created in `skills/` and automatically available to both Claude and Codex.

## Skill Library

The gem ships with these pre-built skills:

- **rails-models** - ActiveRecord patterns, migrations, validations, associations
- **rails-controllers** - Controller actions, routing, REST conventions, filters
- **rails-views** - ERB templates, layouts, partials, forms, helpers
- **rails-hotwire** - Turbo Drive, Turbo Frames, Turbo Streams, Stimulus
- **rails-api-controllers** - API-only controllers, serialization, versioning
- **rspec-testing** - RSpec patterns for models, requests, and system tests
- **rails-jobs** - Active Job patterns, background processing

## How It Works

1. `skills/` is the single source of truth for AI skill files
2. `.claude/skills` is a symlink pointing to `../skills`
3. `.codex/skills` is a symlink pointing to `../skills`
4. Edit skills in `skills/` and both AI tools see the changes immediately

## License

MIT License. See [LICENSE](LICENSE) for details.
