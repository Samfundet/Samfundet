class AddIndicesForPerformanceImprovement < ActiveRecord::Migration[5.2]

  def up
    add_index :job_applications, :job_id
    add_index :job_applications, :withdrawn
    add_index :jobs, :admission_id
    add_index :interviews, :acceptance_status
    add_index :interviews, :job_application_id
  end

  def down
    remove_index :job_applications, :job_id
    remove_index :job_applications, :withdrawn
    remove_index :jobs, :admission_id
    remove_index :interviews, :acceptance_status
    remove_index :interviews, :job_application_id
  end
end
