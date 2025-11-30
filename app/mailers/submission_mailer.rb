class SubmissionMailer < ApplicationMailer
  def new_submission_notification
    @submission = params[:submission]
    @user = @submission.user
    @admin_emails = User.where(admin: true).pluck(:email)

    mail(
      from: "no-reply@work-log.app",
      to: "notification@work-log.app",
      bcc: @admin_emails,
      subject: "New Worklogs Submission from #{@user.full_name}"
    )
  end

  def submission_status_update
    @submission = params[:submission]
    @status = @submission.status
    @submitter_email = @submission.user.email

    mail(
      from: "no-reply@work-log.app",
      to: @submitter_email,
      subject: "Submission Status Update"
    )
  end
end
