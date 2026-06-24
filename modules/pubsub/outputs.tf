output "topic_id" {
  description = "The ID of the created Pub/Sub topic."
  value       = google_pubsub_topic.this.id
}

output "topic_name" {
  description = "The name of the created Pub/Sub topic."
  value       = google_pubsub_topic.this.name
}

output "subscription_ids" {
  description = "A map of subscription keys to resource IDs."
  value       = { for k, v in google_pubsub_subscription.this : k => v.id }
}
