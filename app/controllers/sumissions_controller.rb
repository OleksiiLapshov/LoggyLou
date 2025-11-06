class SubmissionController < ApplicationController
  before_action :require_signin

  def index
    if current_user_admin?
      @submissions = Submission.all
    else
      @submissions = current_user.submissions.all
    end
  end

  def show
    
  end
end