class SubmissionMailer < ApplicationMailer
  def new_submission_notification
    @submission = params[:submission]
    @user = @submission.user
    @admin_emails = User.where(admin: true).pluck(:notification_email)

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
    @user = @submission.user

    mail(
      from: "no-reply@work-log.app",
      to: @user.notification_email,
      subject: "Submission Status Update"
    )
  end

  def submission_reminder_email
    @user = params[:user]

    mail(
      to: @user.notification_email,
      subject: "Reminder: Please submit your timesheet for #{Date.current.strftime('%B')}"
    )
  end
end
