puts "Creating Lyche menu"

Sulten::MenuCategory.create(:title_en => "Starters", :title_no => "Småretter", :order => 1)
Sulten::MenuCategory.create(:title_en => "Burgers", :title_no => "Burgere", :order => 2)
Sulten::MenuCategory.create(:title_en => "Main Courses", :title_no => "Hovedretter", :order => 3)
Sulten::MenuCategory.create(:title_en => "Dessert", :title_no => "Dessert", :order => 4)

12.times.each do |i|
  food = Faker::Food.dish
  description = Faker::Food.description
  allergens = Faker::Food.allergen
  additional_info = rand(0..4) == 0 ? "Additional Info" : nil
  recommendation = rand(0..2) == 0 ? Faker::Beer.name : nil
  order = rand(0..5) == 0 ? nil : rand(0..5)
  Sulten::MenuItem.create(
    :title_no => food,
    :title_en => food,
    :description_no => description,
    :description_en => description,
    :allergens_no => allergens,
    :allergens_en => allergens,
    :recommendation => recommendation,
    :category_id => Sulten::MenuCategory.all.sample.id,
    :price => Faker::Commerce.price,
    :price_member => Faker::Commerce.price,
    :additional_info_no => additional_info,
    :additional_info_en => additional_info,
    :order => order
  )
end