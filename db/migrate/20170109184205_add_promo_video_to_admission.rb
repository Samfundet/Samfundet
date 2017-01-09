class AddPromoVideoToAdmission < ActiveRecord::Migration
  def change
    add_column :admissions, :promo_video, :string, default: "https://www.youtube.com/embed/T8MjwROd0dc" 
  end
end
