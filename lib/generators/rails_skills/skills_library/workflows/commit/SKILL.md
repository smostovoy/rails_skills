---
name: commit
description: Git commit workflow and conventions
version: 1.0.0
---

# Commit Workflow

## Quick Reference

| Command | Purpose |
|---------|---------|
| `git status` | Check what's changed |
| `git diff` | See unstaged changes |
| `git add -p` | Stage interactively |
| `git commit` | Create commit |

## Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Formatting, no code change
- **refactor**: Code change that neither fixes nor adds
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

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

## Workflow

1. **Check status**: `git status`
2. **Review changes**: `git diff`
3. **Stage files**: `git add <files>` (prefer specific files over `-A`)
4. **Commit**: `git commit -m "type: message"`
5. **Push**: `git push`

## Best Practices

1. Commit early, commit often
2. Each commit should be a single logical change
3. Write clear, descriptive commit messages
4. Don't commit generated files, secrets, or large binaries
5. Run tests before committing
