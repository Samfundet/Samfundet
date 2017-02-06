class CreateFeedbacks < ActiveRecord::Migration
  def change

    create_table :feedback_surveys do |t|
      t.string :title
      
      t.timestamps
    end

    create_table :feedback_answers do |t|
      t.decimal :question_id
      t.decimal :alternative
      
      t.timestamps
    end
    
    create_table :feedback_questions do |t|
      t.decimal :survey_id
      t.decimal :index
      t.string :text
      
      
      t.timestamps
    end

    create_table :feedback_alternatives do |t|
      t.decimal :question_id
      t.decimal :index
      t.string :text
      
      t.timestamps
    end

  end
end
