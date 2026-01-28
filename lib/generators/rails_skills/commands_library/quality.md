---
description: Run code quality checks
allowed-tools: Bash, Read
---

## Quality Check

Run the following quality checks on the project and report results:

1. **Linting**: Run `bundle exec rubocop` and report any violations
2. **Tests**: Run `bundle exec rspec` and report failures
3. **Security**: Run `bundle exec brakeman --no-pager` if available

Summarize findings and suggest fixes for any issues found.

Use $ARGUMENTS to scope the check (e.g., a specific file or directory).
