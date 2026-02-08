# rails_skills

A Ruby gem that organizes your knowledge base into AI skills shared between **your team**, **Claude** and **Codex**.

# Structure
It introduces additional layer on top of MVC - intelligence layer. This layer is optimised for reading by both humans and machines.
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
│   ├── stack/                 # Technology stack skills
│   │   └── ruby/
│   │       └── SKILL.md
│   └── workflows/             # Workflows and guides
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
rails generate rails_skills:skill my_folder/my_skill  # custom folders work too
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
