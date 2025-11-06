class SubmissionsController < ApplicationController
  before_action :require_signin

  def index
    if current_user_admin?
      @submissions = Submission.all.order(created_at: :desc)
    else
      @submissions = current_user.submissions.order(created_at: :desc)
    end
  end

  def show

  end
end