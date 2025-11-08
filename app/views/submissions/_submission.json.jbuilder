json.extract! submission, :id, :user_id, :period_start, :period_end, :status, :note, :created_at, :updated_at
json.url submission_url(submission, format: :json)
