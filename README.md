# rails_skills

A Ruby gem that organizes your knowledge base into AI skills shared between **your team**, **Claude** and **Codex**.

# Structure
It introduces additional layer on top of MVC - intelligence layer. This layer is optimised for reading by both humans and machines.
Next structure is default:
| Category | Purpose | Example |
|----------|---------|---------|
| **services/** | Business service skills | `services/payments`, `services/auth` |
| **stack/** | Technology stack skills | `stack/ruby`, `stack/postgres` |
| **workflows/** | Development workflows | `workflows/commit`, `workflows/deploy` |

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
│   ├── stack/                 # Technology stack skills
│   │   └── ruby/
│   │       └── SKILL.md
│   └── workflows/             # Workflow skills
│       ├── commit/
│       │   └── SKILL.md
│       └── rails_skills/
│           └── SKILL.md
├── .claude/
│   ├── skills/                # Flattened symlinks
│   │   ├── ruby -> ../../skills/stack/ruby
│   │   ├── commit -> ../../skills/workflows/commit
│   │   └── rails_skills -> ../../skills/workflows/rails_skills
│   ├── agents/
│   ├── commands/
│   ├── rules/
│   └── settings.local.json
└── .codex/
    └── skills/                # Flattened symlinks
        ├── ruby -> ../../skills/stack/ruby
        ├── commit -> ../../skills/workflows/commit
        └── rails_skills -> ../../skills/workflows/rails_skills
```

Skills are organized by category in `skills/` but flattened when symlinked into `.claude/skills` and `.codex/skills`. For example, `skills/stack/ruby` becomes `.claude/skills/ruby`.

### Create a custom skill

```bash
rails generate rails_skills:skill services/payments
rails generate rails_skills:skill stack/postgres
rails generate rails_skills:skill workflows/deploy --description="Deployment workflow"
```

Skills are created in `skills/` and automatically symlinked (flattened) into both `.claude/skills` and `.codex/skills`.

## Default Skills

The gem ships with these pre-built skills:

- **stack/ruby** - Ruby language patterns, idioms, and best practices
- **workflows/commit** - Git commit workflow to automatically update documentation on each commit
- **workflows/rails_skills** - How to manage AI skills with the rails_skills gem

## Why Flattened Symlinks?

Claude and Codex only load skills from a single flat directory — they do not support nested subdirectories inside their skills path. A skill at `.claude/skills/stack/ruby` would not be discovered.

RailsSkills solves this by keeping a clean categorized structure in `skills/` for humans, while creating flattened symlinks in `.claude/skills/` and `.codex/skills/` so the AI tools can find every skill:

```
skills/stack/ruby          →  .claude/skills/ruby          (discovered)
skills/workflows/commit    →  .claude/skills/commit        (discovered)
skills/stack/ruby          →  .claude/skills/stack/ruby    (NOT discovered)
```

## How It Works

1. `skills/` is the single source of truth, organized by category (`services/`, `stack/`, `workflows/`)
2. Claude and Codex require a flat skills directory — nested paths are not loaded
3. The gem creates flattened symlinks: `skills/stack/ruby` → `.claude/skills/ruby`
4. Edit skills in `skills/` and both AI tools see the changes immediately
5. New skills created via the generator are automatically symlinked

## License

MIT License. See [LICENSE](LICENSE) for details.
