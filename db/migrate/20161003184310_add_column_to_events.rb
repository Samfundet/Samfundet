class AddColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :feedback_survey_id, :integer
    add_column :events, :has_feedback, :boolean
  end
end
