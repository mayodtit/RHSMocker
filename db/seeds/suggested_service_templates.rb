title = 'Find a doctor'
description = <<-eof
We'll find you a doctor close to you who takes your insurance and fits your needs.

**Here's what we'll need from you to find the right fit:**
* Type of doctor
* Your Insurance information
* Your home or work address
* Gender or other preferences

Once we have this, we'll do the search and call each doctors office to ensure the information is up to date. Then we'll send you options of doctors accepting new patients and next available appointment times within one day.

Take 1 minute to share your preferences and we'll take care of the rest.
eof
message = "I want to get started finding a new doctor!"
service_template = ServiceTemplate.find_by_name('provider search')

SuggestedServiceTemplate.upsert_attributes({title: title}, {description: description, message: message, service_template: service_template})
