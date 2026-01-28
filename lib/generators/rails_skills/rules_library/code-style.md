# Code Style Rules

## Ruby Style

- Use 2 spaces for indentation (not tabs)
- Prefer double quotes for strings
- Use modern Ruby syntax (Ruby 3.0+)
- Prefer `&.` safe navigation over conditional checks
- Use trailing commas in multi-line arrays and hashes

## Rails Conventions

- Follow RESTful routing patterns
- Keep controllers thin, models focused
- Use `before_action` for shared controller setup
- Use strong parameters for mass assignment protection
- Prefer ActiveRecord query methods over raw SQL

## Naming

- snake_case for variables, methods, and file names
- PascalCase for classes and modules
- Prefix boolean methods with `?` (e.g., `published?`)
- Prefix destructive methods with `!` (e.g., `publish!`)

## Auto-Fixing

Run `bundle exec rubocop -a` to fix style violations before committing.
