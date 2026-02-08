# rails_skills

A Ruby gem that organizes your knowledge base into AI skills shared between **your team**, **Claude** and **Codex**.

# Structure
It introduces additional layer on top of MVC - intelligence layer. This layer is optimised for reading by both humans and machines.
Next structure is default:
| Category | Purpose | Example |
|----------|---------|---------|
| **domains/** | Business domain knowledge | `domains/payments`, `domains/auth` |
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
│   ├── domains/               # Domain-specific skills
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
rails generate rails_skills:skill domains/payments
rails generate rails_skills:skill stack/postgres
rails generate rails_skills:skill workflows/deploy --description="Deployment workflow"
```

Skills are created in `skills/` and automatically symlinked (flattened) into both `.claude/skills` and `.codex/skills`.

## Default Skills

The gem ships with these pre-built skills:

- **stack/ruby** - Ruby language patterns, idioms, and best practices
- **workflows/commit** - Git commit workflow to automatically update documentation on each commit
- **workflows/rails_skills** - How to manage AI skills with the rails_skills gem

## How It Works

1. `skills/` is the single source of truth, organized by category (`domains/`, `stack/`, `workflows/`)
2. `.claude/skills/` and `.codex/skills/` contain flattened symlinks — each skill is linked directly without the category prefix
3. `skills/stack/ruby` → `.claude/skills/ruby` and `.codex/skills/ruby`
4. Edit skills in `skills/` and both AI tools see the changes immediately
5. New skills created via the generator are automatically symlinked

## License

MIT License. See [LICENSE](LICENSE) for details.
