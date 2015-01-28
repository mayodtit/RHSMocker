ServiceTemplate.find_or_create_by_name(
    name: "provider search",
    title: "Provider Search",
    description: "Find a provider for a member",
    service_type: ServiceType.find_by_name('provider search'),
    time_estimate: 4500
)
ServiceTemplate.find_or_create_by_name(
    name: "30 day experience",
    title: "30 Day Experience",
    description: "Member onboarding process",
    service_type: ServiceType.find_by_name('member onboarding'),
    time_estimate: 43200
)
