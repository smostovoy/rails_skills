# Security Rules

## Input Handling

- Always use strong parameters in controllers
- Never trust user input - validate and sanitize
- Use parameterized queries (ActiveRecord handles this by default)
- Never interpolate user input into SQL strings

## Authentication

- Use established libraries (Devise, etc.) for authentication
- Store passwords with bcrypt (`has_secure_password`)
- Use CSRF protection (enabled by default in Rails)
- Implement proper session management

## Authorization

- Check permissions in every controller action
- Use authorization libraries (Pundit, CanCanCan) for complex rules
- Never rely on hiding UI elements as a security measure

## Output

- ERB auto-escapes output by default - don't bypass with `raw` or `html_safe` unless necessary
- Sanitize HTML content with `sanitize` helper
- Set proper Content Security Policy headers

## Secrets

- Never commit secrets, API keys, or credentials to git
- Use Rails credentials (`rails credentials:edit`) or environment variables
- Add sensitive files to `.gitignore`
