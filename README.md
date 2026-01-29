# rails_skills

A Ruby gem that organizes your knowledge base into AI skills shared between **your team**, **Claude** and **Codex**.

# Structure
It introduces additional layer on top of MVC - intelligence layer. This layer is optimazied for reading by both humans and machines.
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
│       └── commit/
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
- **workflows/commit** - Git commit workflow to automatically update documentation on each commit

## License

MIT License. See [LICENSE](LICENSE) for details.
