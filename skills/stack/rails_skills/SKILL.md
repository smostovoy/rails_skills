---
name: rails_skills
description: Manage skills with the rails_skills gem. Use when asked to install skills, create/update/move a skill, validate SKILL.md frontmatter, run `rails g rails_skills:skill ...`, or map `/rails_skill create ...` shorthand to the proper Rails generator command.
---

# Rails Skills

## Quick Reference

| Command | Purpose |
|---------|---------|
| `rails g rails_skills:install` | Install skills directory and symlinks |
| `rails g rails_skills:skill services/NAME` | Create a service skill |
| `rails g rails_skills:skill stack/NAME` | Create a stack skill |
| `rails g rails_skills:skill workflows/NAME` | Create a workflow skill |
| `rails g rails_skills:skill FOLDER/NAME` | Any custom folder works |
| `/rails_skill create NAME` | Agent CLI shorthand to create `stack/NAME` |
| `bin/rails rails_skills:validate` | Validate all SKILL.md frontmatter |

## Directory Structure

```
skills/                        # Canonical location — edit skills here
  services/                     # Business service knowledge
  stack/                       # Technology stack skills
  workflows/                   # Development workflow skills
.claude/skills/                # Flattened symlinks (auto-managed)
  rails -> ../../skills/stack/rails
  commit -> ../../skills/workflows/commit
.codex/skills/                 # Flattened symlinks (auto-managed)
```

Skills are organized by category in `skills/` but flattened when symlinked. `skills/stack/rails` becomes `.claude/skills/rails`.

## Categories

Any folder under `skills/` is a category. The gem scaffolds three defaults but you can create your own:

| Category | Use for | Examples |
|----------|---------|----------|
| **services/** | Business logic, bounded contexts | `services/payments`, `services/auth`, `services/billing` |
| **stack/** | Languages, frameworks, databases | `stack/rails`, `stack/postgres`, `stack/redis` |
| **workflows/** | Dev processes, CI/CD, conventions | `workflows/commit`, `workflows/deploy`, `workflows/review` |
| **your_folder/** | Anything you need | `your_folder/my_skill` |

## Creating Skills

```bash
# Basic skill
rails g rails_skills:skill stack/postgres

# With custom description
rails g rails_skills:skill services/payments --description="Payment processing patterns"

# With references directory for supplementary files
rails g rails_skills:skill stack/redis --with-references
```

The generator creates the skill in `skills/` and automatically symlinks it into `.claude/skills/` and `.codex/skills/`.

## Agent CLI Shorthand

When an agent CLI sends `/rails_skill create ...`, map it to the Rails generator:

```bash
# Default category is stack/
/rails_skill create new_skill
# -> bin/rails g rails_skills:skill stack/new_skill

# Explicit category/path is passed through
/rails_skill create services/payments
# -> bin/rails g rails_skills:skill services/payments
```

## Skill File Format

Each skill lives in its own directory with a `SKILL.md` file:

```markdown
---
name: skill_name
description: What this skill teaches
---

# Skill Name

## Quick Reference
| Pattern | Example |
|---------|---------|

## Usage
Code examples and patterns.

## Best Practices
Conventions and guidelines.
```

## CI and Validation

Validate all `SKILL.md` frontmatter locally:

```bash
bin/rails rails_skills:validate
```

Add to your CI pipeline:

```yaml
# .github/workflows/ci.yml
- name: Validate skills
  run: bin/rails rails_skills:validate
```

The validator checks that every `SKILL.md` has YAML frontmatter with required `name` and `description` keys. The task exits non-zero on failure, so it will fail your CI build if any skill is invalid.

## Best Practices

1. One skill per concept — keep skills focused and single-purpose
2. Use quick reference tables for scannable lookup
3. Include real code examples over abstract descriptions
4. Put service skills close to the business language your team uses
5. Update skills when patterns evolve — they are living documentation
6. Skills are shared between Claude and Codex — write for both audiences
