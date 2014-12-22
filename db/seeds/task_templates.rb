# Provider Search --
TaskTemplate.find_or_create_by_name(
    name: "collect information",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Collect information from search",
    description: "Find a provider for a member",
    time_estimate: 900,
    service_ordinal: 1
).create_guides!(["This is a guide", "This is another guide", "a third guide?"])
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
    description: "1) Send introduction message<br>2) Review profile information entered by HCC",
    time_estimate: 900,
    service_ordinal: 5
)

# 30 Day Experience --
TaskTemplate.find_or_create_by_name(
    name: "PHA introduction",
    service_template: ServiceTemplate.find_by_name('30 day experience'),
    title: "PHA Introduction",
    description: "Find a provider for a member",
    time_estimate: 120,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "complete member profile",
    service_template: ServiceTemplate.find_by_name('30 day experience'),
    title: "Complete Profile",
    description: "Data to complete:<br> - Address<br> - Birthday<br> - Gender<br> - Insurance Information<br> - Current Care Team<br> - Medical Conditions<br> - Height and Weight (for WM only)<br> - Due date (for Pregnancy only)",
    time_estimate: 10000,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "offer insurance review service",
    service_template: ServiceTemplate.find_by_name('30 day experience'),
    title: "Offer Insurance Review Service",
    description: "Chances are you may not know everything about your health insurance coverage, like if you’re using all of your benefits or what appointments are covered. I’d like to break down your plan to see if you’re getting the most out of your insurance. Does that sound helpful to you?",
    time_estimate: 10000,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "prevention screenings",
    service_template: ServiceTemplate.find_by_name('30 day experience'),
    title: "Perform Preventive Screening Service",
    description: "See website for details based on age/gender",
    time_estimate: 10000,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "offer creating care team service",
    service_template: ServiceTemplate.find_by_name('30 day experience'),
    title: "Offer Creating Care Team Service",
    description: "We want to ensure that you have doctors you need and like, are organized with your annual appointment schedule, and have a health record that is shared among their current providers. Would this be helpful for you?",
    time_estimate: 10000,
    service_ordinal: 1
)
