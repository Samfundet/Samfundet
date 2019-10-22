class AddPromoVideoToAdmission < ActiveRecord::Migration[5.1]
  def change
    add_column :admissions, :promo_video, :string, default: "https://www.youtube.com/embed/T8MjwROd0dc" 
  end
end
