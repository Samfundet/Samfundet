class CreateFeedbacks < ActiveRecord::Migration
  def change

    create_table :feedback_surveys do |t|
      t.string :title
      
      t.timestamps
    end

    create_table :feedback_answers do |t|
      t.integer :question_id
      t.integer :alternative
      
      t.timestamps
    end
    
    create_table :feedback_questions do |t|
      t.integer :index
      t.string :text

      t.timestamps
    end

    create_table :feedback_alternatives do |t|
      t.integer :question_id
      t.integer :index
      t.string :text
      
      t.timestamps
    end

    create_table :feedback_surveys_questions do |t|
      t.integer :question_id
      t.integer :survey_id
    end

  end
end
