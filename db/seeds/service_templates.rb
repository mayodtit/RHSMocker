ServiceTemplate.find_or_create_by_name(
    name: "mayo pilot 2",
    title: "Mayo Pilot 2 - Stroke",
    description: "Stroke patients need extra attention in the first 30 days. Use the following tasks as message suggestions. If you are already working with member you can abandon the message.",
    service_type: ServiceType.find_by_name('member onboarding'),
    time_estimate: 4500
)
