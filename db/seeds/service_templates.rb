ServiceTemplate.find_or_create_by_name(
    name: "mayo pilot 2",
    title: "Mayo Pilot 2 - Stroke",
    description: "Stroke patients need extra attention in the first 30 days. Use the following tasks as message suggestions. If you are already working with member you can abandon the message.",
    service_type: ServiceType.find_by_name('member onboarding'),
    time_estimate: 43200,
    timed_service: true
)

PROVIDER_SEARCH_DESCRIPTION = <<-eof
#Member preference checklist
* **Type of Doctor:**
* **Location (zip):**
* **Preferences (if any):**
* **Reason for visit:**
* **Insurance plan:**
* **Insurance website:**
* **Employer/Exchanges:**

#PHA message to send (paste templated options here):
eof

ServiceTemplate.find_or_create_by_name(
    name: "provider search",
    title: "Provider Search",
    description: PROVIDER_SEARCH_DESCRIPTION,
    service_type: ServiceType.find_by_name('provider search'),
    time_estimate: 4500
)
