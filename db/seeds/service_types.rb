# Service Types -
ServiceType.find_or_create_by_name(name: 'other', bucket: 'other')

# Insurance --
ServiceType.find_or_create_by_name(name: 'benefit evaluation', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'claims', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'cost estimation', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'deductible/FSA/HSA status assessment', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'eligibility check', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'grievances', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'insurance plan - search', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'insurance plan - buying/applying', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'PHA designation for authorization', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'pre/prior authorization for service', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'temporary insurance', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'other insurance', bucket: 'insurance')

# Care Coordination --
ServiceType.find_or_create_by_name(name: 'appointment booking', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'appointment preparation', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'facility search (hospital, assisted living, etc)', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'specialist/2nd opinion', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'medical/clinical research', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'natural disaster preparedness', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'provider search', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'record recovery', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'prescription management', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'symptom management', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'other care coordination', bucket: 'care coordination')

# Engagement --
ServiceType.find_or_create_by_name(name: 'welcome call', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'check-in call', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'collect member due date', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'outbound call', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'member onboarding', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'member offboarding', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'preventive care reminders', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'send pregnancy content card', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 're-engagement', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'relevant content', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'themed months questions and content', bucket: 'engagement')
s = ServiceType.find_by_name('other care engagement')
s.destroy if s
ServiceType.find_or_create_by_name(name: 'other engagement', bucket: 'engagement')

# Wellness --
ServiceType.find_or_create_by_name(name: 'exercise assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'nutrition assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'sleep assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'stress assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'wellness research', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'other wellness', bucket: 'wellness')
# Wellness -- weight mgmnt
ServiceType.find_or_create_by_name(name: 'celebration video', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'set goal', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'member completes goal', bucket: 'wellness')
