---
name: cli
description: Command-line workflows for Rails development
version: 1.0.0
---

# CLI Workflows

## Quick Reference

| Command | Purpose |
|---------|---------|
| `rails s` | Start development server |
| `rails c` | Open Rails console |
| `rails db:migrate` | Run pending migrations |
| `rails g model Name` | Generate a model |
| `bundle exec rspec` | Run tests |

## Rails Commands

```bash
# Server
rails server                    # Start on port 3000
rails s -p 4000                 # Start on port 4000
rails s -b 0.0.0.0              # Bind to all interfaces

# Console
rails console                   # Development console
rails c -e production           # Production console
rails c --sandbox               # Rollback changes on exit

# Database
rails db:create                 # Create database
rails db:migrate                # Run migrations
rails db:rollback               # Undo last migration
rails db:seed                   # Run seeds
rails db:reset                  # Drop, create, migrate, seed

# Generators
rails g model User name:string
rails g controller Posts index show
rails g migration AddEmailToUsers email:string
rails g scaffold Post title:string body:text
rails destroy model User        # Undo generator
```

## Rake Tasks

```bash
# List all tasks
rails -T
rails -T db                     # Filter by namespace

# Common tasks
rails routes                    # Show all routes
rails routes -g users           # Filter routes
rails stats                     # Code statistics
rails notes                     # Show TODO/FIXME comments
rails middleware                # List middleware stack
```

## Bundle

```bash
bundle install                  # Install gems
bundle update                   # Update all gems
bundle update gem_name          # Update specific gem
bundle exec command             # Run with bundled gems
bundle outdated                 # Show outdated gems
```

## Testing

```bash
# RSpec
bundle exec rspec
bundle exec rspec spec/models/
bundle exec rspec spec/models/user_spec.rb:42

# Minitest
rails test
rails test test/models/
rails test test/models/user_test.rb:42
```

## Debugging

```bash
# Logs
tail -f log/development.log
rails log:clear                 # Truncate logs

# Database
rails dbconsole                 # Open database CLI
rails db:schema:dump            # Regenerate schema.rb
```

## Best Practices

1. Use `bundle exec` for gem commands
2. Run `rails db:migrate` after pulling changes
3. Check `rails routes` when debugging routing issues
4. Use `--sandbox` in console when exploring production data
5. Run tests before committing
