---
name: rails-hotwire
description: Turbo Drive, Turbo Frames, Turbo Streams, and Stimulus
version: 1.0.0
---

# Rails Hotwire

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Turbo Frame** | `<%= turbo_frame_tag "name" do %>` |
| **Turbo Stream** | `<%= turbo_stream.append "list" do %>` |
| **Stimulus controller** | `data-controller="toggle"` |
| **Stimulus action** | `data-action="click->toggle#switch"` |
| **Stimulus target** | `data-toggle-target="content"` |

## Turbo Frames

```erb
<%# Wrap content in a frame %>
<%= turbo_frame_tag "post_#{@post.id}" do %>
  <h2><%= @post.title %></h2>
  <%= link_to "Edit", edit_post_path(@post) %>
<% end %>

<%# Lazy-loaded frame %>
<%= turbo_frame_tag "comments", src: post_comments_path(@post), loading: :lazy do %>
  <p>Loading comments...</p>
<% end %>
```

## Turbo Streams

```erb
<%# app/views/posts/create.turbo_stream.erb %>
<%= turbo_stream.prepend "posts" do %>
  <%= render @post %>
<% end %>

<%= turbo_stream.update "flash" do %>
  <div class="notice">Post created!</div>
<% end %>

<%# Actions: append, prepend, replace, update, remove, before, after %>
```

### Broadcasts from Model

```ruby
class Post < ApplicationRecord
  after_create_commit { broadcast_prepend_to "posts" }
  after_update_commit { broadcast_replace_to "posts" }
  after_destroy_commit { broadcast_remove_to "posts" }
end
```

## Stimulus

```javascript
// app/javascript/controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTarget.classList.toggle("hidden")
  }
}
```

```erb
<div data-controller="toggle">
  <button data-action="click->toggle#toggle">Toggle</button>
  <div data-toggle-target="content">
    Content here
  </div>
</div>
```

## Best Practices

1. Start with Turbo Drive (enabled by default)
2. Use Turbo Frames for in-page updates
3. Use Turbo Streams for multi-element updates
4. Use Stimulus only when HTML-over-the-wire isn't enough
5. Keep Stimulus controllers small and focused
