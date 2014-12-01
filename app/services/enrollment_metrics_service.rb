class EnrollmentMetricsService
  def initialize(options={})
    @from = options[:from]
    @to = options[:to]
  end

  def call
    [
      total_enrollments,
      enrollments_with_email,
      completed_enrollments
    ]
  end

  private

  def enrollments
    @enrollments = Enrollment.scoped
    @enrollments = @enrollments.where('created_at > ?', @from) if @from
    @enrollments = @enrollments.where('created_at < ?', @to) if @to
    @enrollments
  end

  def total_enrollments
    {
      label: 'Launched install',
      value: enrollments.count
    }
  end

  def enrollments_with_email
    {
      label: 'User entered email',
      value: enrollments.where('email IS NOT NULL').count
    }
  end

  def completed_enrollments
    {
      label: 'Completed enrollment',
      value: enrollments.where('user_id IS NOT NULL').count
    }
  end
end
