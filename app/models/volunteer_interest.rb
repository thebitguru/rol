class VolunteerInterest < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :interest
end
