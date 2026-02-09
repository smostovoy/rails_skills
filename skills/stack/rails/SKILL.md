---
name: rails
description: Rails framework workflows and command execution patterns. Use when context includes Rails CLI-like text to normalize it into a valid command and run it, and when documenting Rails project best practices.
---

# Rails

## Quick Reference

| Task | Example |
|------|---------|
| Normalize command | `g model User name:string` -> `bin/rails g model User name:string` |
| Prefer app binstub | `rails db:migrate` -> `bin/rails db:migrate` |
| Run in app root | Execute from repository root containing `bin/rails` |

## Rails CLI Handling

1. Detect Rails-like command text in context (`g`, `generate`, `db:migrate`, `runner`, `console`, `rails ...`).
2. Normalize to full command:
   - Prefix with `bin/rails` when missing.
   - Expand short aliases when useful (`g` -> `generate`, `d` -> `destroy`).
   - Preserve user arguments and ordering.
3. Run the command from project root.
4. Report the executed command and key output/errors.

## Best Practices

```text
# reference rubocop here or write your project rails rules
```
