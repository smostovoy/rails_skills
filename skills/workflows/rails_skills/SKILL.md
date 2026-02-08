---
name: rails_skills
description: How to manage AI skills with the rails_skills gem
---

# Rails Skills

## Quick Reference

| Command | Purpose |
|---------|---------|
| `rails g rails_skills:install` | Install skills directory and symlinks |
| `rails g rails_skills:skill domains/NAME` | Create a domain skill |
| `rails g rails_skills:skill stack/NAME` | Create a stack skill |
| `rails g rails_skills:skill workflows/NAME` | Create a workflow skill |

## Directory Structure

```
skills/                        # Canonical location — edit skills here
  domains/                     # Business domain knowledge
  stack/                       # Technology stack skills
  workflows/                   # Development workflow skills
.claude/skills/                # Flattened symlinks (auto-managed)
  ruby -> ../../skills/stack/ruby
  commit -> ../../skills/workflows/commit
.codex/skills/                 # Flattened symlinks (auto-managed)
```

Skills are organized by category in `skills/` but flattened when symlinked. `skills/stack/ruby` becomes `.claude/skills/ruby`.

## Categories

| Category | Use for | Examples |
|----------|---------|----------|
| **domains/** | Business logic, bounded contexts | `domains/payments`, `domains/auth`, `domains/billing` |
| **stack/** | Languages, frameworks, databases | `stack/ruby`, `stack/postgres`, `stack/redis` |
| **workflows/** | Dev processes, CI/CD, conventions | `workflows/commit`, `workflows/deploy`, `workflows/review` |

## Creating Skills

```bash
# Basic skill
rails g rails_skills:skill stack/postgres

# With custom description
rails g rails_skills:skill domains/payments --description="Payment processing patterns"

# With references directory for supplementary files
rails g rails_skills:skill stack/redis --with-references
```

The generator creates the skill in `skills/` and automatically symlinks it into `.claude/skills/` and `.codex/skills/`.

## Skill File Format

Each skill lives in its own directory with a `SKILL.md` file:

```markdown
---
name: skill_name
description: What this skill teaches
version: 1.0.0
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

## Best Practices

1. One skill per concept — keep skills focused and single-purpose
2. Use quick reference tables for scannable lookup
3. Include real code examples over abstract descriptions
4. Put domain skills close to the business language your team uses
5. Update skills when patterns evolve — they are living documentation
6. Skills are shared between Claude and Codex — write for both audiences
