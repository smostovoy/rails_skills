---
name: rspec-testing
description: RSpec testing patterns for models, controllers, requests, and system tests
version: 1.0.0
---

# RSpec Testing

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Run all** | `bundle exec rspec` |
| **Run file** | `bundle exec rspec spec/models/user_spec.rb` |
| **Run line** | `bundle exec rspec spec/models/user_spec.rb:15` |
| **Run tag** | `bundle exec rspec --tag focus` |

## Model Specs

```ruby
RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe "associations" do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to belong_to(:organization).optional }
  end

  describe "#full_name" do
    it "returns first and last name" do
      user = build(:user, first_name: "Jane", last_name: "Doe")
      expect(user.full_name).to eq("Jane Doe")
    end
  end
end
```

## Request Specs

```ruby
RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "returns a successful response" do
      get posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    let(:valid_params) { { post: { title: "Test", body: "Content" } } }

    it "creates a post" do
      expect {
        post posts_path, params: valid_params
      }.to change(Post, :count).by(1)
    end
  end
end
```

## System Specs

```ruby
RSpec.describe "Managing posts", type: :system do
  before { driven_by(:rack_test) }

  it "allows creating a new post" do
    visit new_post_path
    fill_in "Title", with: "My Post"
    fill_in "Body", with: "Content"
    click_on "Create Post"

    expect(page).to have_content("Post created")
    expect(page).to have_content("My Post")
  end
end
```

## Factories (FactoryBot)

```ruby
FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { Faker::Internet.email }
    role { "viewer" }

    trait :admin do
      role { "admin" }
    end
  end
end
```

## Best Practices

1. Test behavior, not implementation
2. Use `let` and `before` for setup, keep `it` blocks focused
3. Use factories instead of fixtures
4. Write request specs over controller specs
5. Use `have_http_status` for response assertions
6. Keep specs fast - minimize database interactions
