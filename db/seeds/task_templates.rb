# Provider Search --
TaskTemplate.find_or_create_by_name(
    name: "collect information",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Collect information from search",
    description: "Find a provider for a member",
    time_estimate: 900,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "perform provider search",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Perform provider search",
    description: "Find a provider for a member",
    time_estimate: 900,
    service_ordinal: 2
)
TaskTemplate.find_or_create_by_name(
    name: "send member options",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Send member the options",
    description: "Find a provider for a member",
    time_estimate: 900,
    service_ordinal: 3
)
TaskTemplate.find_or_create_by_name(
    name: "schedule follow up message",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Sechedule message to follow up on options",
    description: "Find a provider for a member",
    time_estimate: 900,
    service_ordinal: 4
)
TaskTemplate.find_or_create_by_name(
    name: "assign next",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Assign next tasks or services",
    description: "Find a provider for a member",
    time_estimate: 900,
    service_ordinal: 5
)
