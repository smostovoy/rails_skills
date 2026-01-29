---
name: commit
description: Git commit workflow and conventions
---

# Workflow

1. **Check status**: `git status`
2. **Review changes**: `git diff`
3. **Analyze missing docs/skills** - If you see changes to domains listed in skills/domains - review the need to update the skill doc
3. **Stage files**: `git add <files>` (prefer specific files over `-A`)
4. **Commit**: `git commit -m "type: message"`
5. **Push**: Push only if explicitly asked so, use `git push origin {current branch}`

# Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

## Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Formatting, no code change
- **refactor**: Code change that neither fixes nor adds
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

## Examples

```
feat: Add user authentication

Implement login/logout functionality using Devise.
Includes email/password authentication and session management.

Closes #123
```

```
fix: Prevent duplicate form submissions

Add disable_with to submit buttons to prevent
users from clicking multiple times.
```
