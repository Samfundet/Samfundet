puts "Creating images"
image_list = ["concert1.jpg", "concert2.jpg", "concert3.jpg", "concert4.jpg", "concert5.jpg"]
image_list.each do |image|
  Image.create!(
      title: image,
      image_file: File.open(Rails.root.join('app', 'assets', 'images', image)),
      uploader: Member.find_by(mail: 'myrlund@gmail')
    )
  print "#{image}..."
end

# Create default image
Image.create!(
  title: Image::DEFAULT_TITLE,
  image_file: File.open(Image::DEFAULT_PATH))

puts "Done creating images!"