class NewKinsightsMemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :subject, class_name: 'User'

  attr_accessible :subject, :subject_id

  validates :member, :subject, presence: true

  private

  def default_queue
    :hcc
  end

  def set_defaults
    self.title ||= "PHA Introduction - Kinsights"
    self.description ||= default_description
    self.creator ||= Member.robot
    self.due_at ||= Time.now + 5.minutes
    self.priority ||= 7
    super
  end

  def default_description
<<-eof
Link to HCC flow on website:  https://betterpha.squarespace.com/kinsights-pilot/

#HCC Instructions
**Collect KInsight data**
Open Kinsights to review / Collect Data
Kinsights Patient URL: #{subject.kinsights_patient_url}
Kinsights Profile URL: #{subject.kinsights_profile_url}
username: BetterPHA
password: G3tB3tt3r!
Add in member data to profile/ update section:
  * Child’s name
  * Child’s DOB
  * Height, weight, BMI
  * Any allergies
  * Medical Conditions: Cystic Fibrosis
  * Immunizations

**Add Asana Task for add profile for child:**
  1 .[Click here](https://app.asana.com/0/22759152719009/22759152719009) to add member to Baymax Asana Project and find template for kinsight. Copy template to create the task
  2. Title the task: Kinsights- Member ID #
  3. Paste the careportal member link into task
  4. List name of child/family and birthday
  5. Assign to Kyle to be due same day and you're done!
eof
  end
end
