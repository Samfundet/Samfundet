puts "Creating images"
image_list = ["seed/banner01.jpg", "seed/banner02.jpg", "seed/banner03.jpg", "seed/banner04.jpg", "seed/banner05.jpg"]
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