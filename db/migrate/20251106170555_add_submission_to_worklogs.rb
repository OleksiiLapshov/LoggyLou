class AddSubmissionToWorklogs < ActiveRecord::Migration[8.0]
  def change
    add_reference :worklogs, :submission, foreign_key: true
  end
end
