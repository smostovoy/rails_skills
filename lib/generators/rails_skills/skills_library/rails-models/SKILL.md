---
name: rails-models
description: ActiveRecord patterns, migrations, validations, callbacks, associations
version: 1.0.0
---

# Rails Models (ActiveRecord)

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Generate model** | `rails g model User name:string email:string` |
| **Migration** | `rails g migration AddAgeToUsers age:integer` |
| **Validation** | `validates :email, presence: true, uniqueness: true` |
| **Association** | `has_many :posts, dependent: :destroy` |
| **Scope** | `scope :active, -> { where(active: true) }` |

## Model Structure

```ruby
class User < ApplicationRecord
  # Constants
  ROLES = %w[admin editor viewer].freeze

  # Associations
  has_many :posts, dependent: :destroy
  belongs_to :organization, optional: true

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :role, inclusion: { in: ROLES }

  # Callbacks
  before_save :normalize_email

  # Scopes
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }

  # Enums
  enum :status, { pending: 0, active: 1, archived: 2 }

  private

  def normalize_email
    self.email = email.downcase.strip
  end
end
```

## Migrations

```ruby
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :active, default: true
      t.references :organization, foreign_key: true
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
```

## Associations

- `has_many :items, dependent: :destroy`
- `belongs_to :parent, optional: true`
- `has_many :tags, through: :taggings`
- `has_one :profile, dependent: :destroy`
- `has_many :comments, as: :commentable` (polymorphic)

## Validations

- `validates :field, presence: true`
- `validates :email, uniqueness: { case_sensitive: false }`
- `validates :age, numericality: { greater_than: 0 }`
- `validates :field, length: { minimum: 2, maximum: 100 }`
- `validates :field, format: { with: /\Apattern\z/ }`
- `validate :custom_validation_method`

## Queries

```ruby
User.where(active: true)
User.where.not(role: "guest")
User.joins(:posts).where(posts: { published: true })
User.includes(:posts).order(created_at: :desc)
User.pluck(:id, :name)
User.group(:role).count
```

## Best Practices

1. Add database-level constraints (NOT NULL, unique indexes, foreign keys)
2. Use `includes` to avoid N+1 queries
3. Keep callbacks simple, use service objects for complex logic
4. Use scopes for reusable query fragments
5. Use concerns to share behavior across models
