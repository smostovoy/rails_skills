---
name: rails-controllers
description: Controller actions, routing, REST conventions, filters, strong parameters
version: 1.0.0
---

# Rails Controllers

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Generate** | `rails g controller Posts index show` |
| **Route** | `resources :posts` |
| **Filter** | `before_action :set_post, only: [:show, :edit, :update, :destroy]` |
| **Strong params** | `params.require(:post).permit(:title, :body)` |
| **Redirect** | `redirect_to @post, notice: "Created!"` |
| **Render** | `render :new, status: :unprocessable_entity` |

## Controller Structure

```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :published)
  end
end
```

## Routing

```ruby
Rails.application.routes.draw do
  resources :posts
  resources :posts, only: [:index, :show]

  resources :authors do
    resources :posts, shallow: true
  end

  resources :posts do
    member { post :publish }
    collection { get :archived }
  end

  namespace :admin do
    resources :users
  end
end
```

## Response Formats

```ruby
respond_to do |format|
  format.html { redirect_to @post }
  format.json { render json: @post, status: :created }
  format.turbo_stream
end
```

## Error Handling

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render file: Rails.root.join("public/404.html"), status: :not_found
  end
end
```

## Best Practices

1. Keep controllers thin - move logic to models or service objects
2. Always use strong parameters
3. Use `before_action` for shared setup
4. Return proper HTTP status codes
5. Follow RESTful conventions
