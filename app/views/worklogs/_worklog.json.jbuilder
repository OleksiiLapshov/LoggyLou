json.extract! worklog, :id, :employee, :hours, :note, :project, :log_date, :created_at, :updated_at
json.url worklog_url(worklog, format: :json)
