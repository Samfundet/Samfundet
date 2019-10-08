class AddMarkdownToAdmission < ActiveRecord::Migration[5.1]
  def change
    add_column :admissions, :groups_with_separate_admission, :text
  end
end
