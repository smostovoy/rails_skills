---
name: rails-views
description: ERB templates, layouts, partials, forms, and view helpers
version: 1.0.0
---

# Rails Views

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Output** | `<%= @post.title %>` |
| **Logic** | `<% if condition %>` |
| **Partial** | `<%= render "shared/header" %>` |
| **Collection** | `<%= render @posts %>` |
| **Form** | `<%= form_with model: @post do \|f\| %>` |
| **Link** | `<%= link_to "Home", root_path %>` |

## Layouts

```erb
<!DOCTYPE html>
<html>
  <head>
    <title><%= content_for?(:title) ? yield(:title) : "App" %></title>
    <%= csrf_meta_tags %>
    <%= stylesheet_link_tag "application" %>
    <%= javascript_importmap_tags %>
  </head>
  <body>
    <% flash.each do |type, message| %>
      <div class="flash flash-<%= type %>"><%= message %></div>
    <% end %>
    <%= yield %>
  </body>
</html>
```

## Partials

```erb
<%# Render a partial %>
<%= render "post", post: @post %>

<%# Render a collection %>
<%= render partial: "post", collection: @posts %>

<%# Shorthand for collection %>
<%= render @posts %>
```

## Forms

```erb
<%= form_with model: @post do |f| %>
  <div>
    <%= f.label :title %>
    <%= f.text_field :title %>
  </div>

  <div>
    <%= f.label :body %>
    <%= f.text_area :body %>
  </div>

  <div>
    <%= f.label :category_id %>
    <%= f.collection_select :category_id, Category.all, :id, :name, prompt: "Select" %>
  </div>

  <%= f.submit %>
<% end %>
```

## Helpers

```ruby
module ApplicationHelper
  def page_title(title)
    content_for(:title) { title }
    content_tag(:h1, title)
  end

  def active_class(path)
    current_page?(path) ? "active" : ""
  end
end
```

## Turbo Frames

```erb
<%= turbo_frame_tag "post_#{@post.id}" do %>
  <%= render @post %>
<% end %>

<%= turbo_frame_tag "post", src: post_path(@post), loading: :lazy do %>
  Loading...
<% end %>
```

## Best Practices

1. Keep logic out of views - use helpers or presenters
2. Use partials for reusable components
3. Always escape user input (ERB does this by default)
4. Use `content_for` for flexible layouts
5. Use Turbo Frames for partial page updates
