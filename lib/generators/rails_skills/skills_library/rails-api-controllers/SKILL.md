---
name: rails-api-controllers
description: API-only controllers, serialization, authentication, versioning
version: 1.0.0
---

# Rails API Controllers

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Base class** | `class Api::V1::PostsController < ActionController::API` |
| **Render JSON** | `render json: @post, status: :ok` |
| **Error response** | `render json: { error: "Not found" }, status: :not_found` |
| **Pagination** | `@posts = Post.page(params[:page]).per(25)` |

## API Controller Structure

```ruby
module Api
  module V1
    class PostsController < ApplicationController
      def index
        posts = Post.order(created_at: :desc).page(params[:page])
        render json: posts
      end

      def show
        post = Post.find(params[:id])
        render json: post
      end

      def create
        post = Post.new(post_params)

        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        post = Post.find(params[:id])

        if post.update(post_params)
          render json: post
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        post = Post.find(params[:id])
        post.destroy
        head :no_content
      end

      private

      def post_params
        params.require(:post).permit(:title, :body, :published)
      end
    end
  end
end
```

## API Routing

```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts
      resources :users, only: [:index, :show]
    end
  end
end
```

## Error Handling

```ruby
module Api
  class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e.message }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { error: e.message }, status: :bad_request
    end
  end
end
```

## Best Practices

1. Use API-only base class (`ActionController::API`)
2. Version your API with namespaces
3. Return consistent error formats
4. Use proper HTTP status codes
5. Paginate list endpoints
6. Use serializers for complex JSON responses
