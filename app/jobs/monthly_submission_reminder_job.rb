class MonthlySubmissionReminderJob < ApplicationJob
  queue_as :default

  def perform
    return unless today_is_last_working_day?
    send_reminders
  end

  private

  def today_is_last_working_day?
    today = Date.current
    last_day_of_month = today.end_of_month
    target_date = last_day_of_month

    # crawling backwards to remove "weekend" days if those are last days of the month
    while target_date.on_weekend?
      target_date -= 1.day
    end

    today == target_date # returns true if today is a last working day
  end

  def send_reminders
    current_period = Date.current.beginning_of_month
    User.where(admin: false).find_each do |user|
      has_submission = user.submissions.exists?(period_start: current_period)
      unless has_submission
        SubmissionMailer.with(user: user).submission_reminder_email.deliver_later
      end
    end
  end
end
