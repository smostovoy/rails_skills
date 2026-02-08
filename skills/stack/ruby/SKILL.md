---
name: ruby
description: Ruby language patterns, idioms, and best practices
version: 1.0.0
---

# Ruby

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Safe navigation** | `user&.name` |
| **Dig** | `hash.dig(:user, :address, :city)` |
| **Transform keys** | `hash.transform_keys(&:to_sym)` |
| **Compact** | `array.compact` |
| **Then/yield_self** | `value.then { \|v\| process(v) }` |

## Idioms

```ruby
# Guard clauses
def process(user)
  return unless user
  return if user.inactive?
  # main logic
end

# Safe navigation
user&.profile&.avatar_url

# Hash with default
counts = Hash.new(0)
counts[:views] += 1

# Destructuring
first, *rest = array
hash => { name:, email: }

# Enumerable
users.map(&:name)
users.select(&:active?)
users.find { |u| u.admin? }
users.group_by(&:role)
users.index_by(&:id)
```

## Collections

```ruby
# Map with index
items.each_with_index { |item, i| }
items.map.with_index { |item, i| }

# Reduce
numbers.reduce(0) { |sum, n| sum + n }
numbers.sum

# Partition
active, inactive = users.partition(&:active?)

# Zip
names.zip(emails).map { |name, email| { name:, email: } }
```

## Blocks & Procs

```ruby
# Block to proc
users.map(&:name)

# Method reference
users.map(&method(:process))

# Proc/Lambda
square = ->(x) { x * x }
square.call(5)
```

## Best Practices

1. Prefer guard clauses over nested conditionals
2. Use `&.` safe navigation over `try` or conditionals
3. Use symbols for hash keys
4. Prefer `each` over `for`
5. Use `freeze` for constants: `ROLES = %w[admin user].freeze`
