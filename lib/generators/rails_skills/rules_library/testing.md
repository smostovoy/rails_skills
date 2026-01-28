# Testing Rules

## General

- Every feature must have tests
- Test behavior, not implementation details
- Keep tests fast and independent
- Use factories (FactoryBot) over fixtures

## Test Types

- **Model specs** for validations, associations, and business logic
- **Request specs** for controller actions and API endpoints
- **System specs** for user-facing workflows (use sparingly)

## Conventions

- One assertion per test when practical
- Use `let` for lazy setup, `let!` when eager evaluation is needed
- Use `describe` for the subject, `context` for conditions, `it` for behavior
- Name tests clearly: `it "returns published posts for active users"`

## Running Tests

- `bundle exec rspec` to run all tests
- `bundle exec rspec spec/models/` to run model specs
- `bundle exec rspec spec/file.rb:42` to run a specific test
