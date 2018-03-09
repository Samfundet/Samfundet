class AddMarkdownToAdmission < ActiveRecord::Migration
  def change
    add_column :admissions, :groups_with_separate_admission, :text
  end
end
