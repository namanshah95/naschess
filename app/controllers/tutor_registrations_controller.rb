class TutorRegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    Activity.create!({activity_type: "TUTOR_SIGNUP", user_id: resource.id})
  end

  def update
    super
  end
end 