---
name: rails-jobs
description: Active Job patterns, Sidekiq, background processing
version: 1.0.0
---

# Rails Background Jobs

## Quick Reference

| Pattern | Example |
|---------|---------|
| **Generate** | `rails g job ProcessOrder` |
| **Enqueue** | `ProcessOrderJob.perform_later(order)` |
| **Enqueue later** | `ProcessOrderJob.set(wait: 5.minutes).perform_later(order)` |
| **Enqueue at** | `ProcessOrderJob.set(wait_until: Date.tomorrow.noon).perform_later(order)` |

## Job Structure

```ruby
class ProcessOrderJob < ApplicationJob
  queue_as :default
  retry_on ActiveRecord::Deadlocked, wait: 5.seconds, attempts: 3
  discard_on ActiveJob::DeserializationError

  def perform(order)
    order.process!
    OrderMailer.confirmation(order).deliver_later
  end
end
```

## Best Practices

1. Keep jobs idempotent
2. Pass IDs instead of full objects when possible
3. Use appropriate queues for different priorities
4. Handle retries and failures gracefully
5. Monitor queue depths in production
