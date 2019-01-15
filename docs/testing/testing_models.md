# Testing models

We're going to go through a simple example for testing a model. To test a model, say `Blog` (a blog post), create a new Ruby file in `spec/models` called `blog_spec` and fill it with the following template code:

```ruby
# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe Blog do
  # Here goes the tests
end
```

At the same time we're going to create a factory method by creating a file called `blog_factory` in `spec/factories`. This simplifies creating objects in our tests. (For a `Blog` we must also create a factory method for `Image`, but this you can find in `spec/factories/image_factory.rb`.). Fill it with this:

```ruby
# frozen_string_literal: true

FactoryGirl.define do
  factory :blog do
    title_no "Test"
    title_en "Test"
    lead_paragraph_no "Test"
    lead_paragraph_en "Test"
    content_no "Test"
    content_en "Test"
    publish_at Time.current
    author_id "Test"
    image_id "Test"
  end
end
```

A `Blog` has different attributes, say `title_no`, which is the Norwegian title of the blog post. These attributes are validated when we create an object. Continuing on the first code block, we want to test that we can't create a `Blog` object without a Norwegian title. Then we can do the following:

```ruby
# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe Blog do
  before do
      @member = create(:member)
      @image = create(:image)
  end

  it 'should have a title_no greater than zero characters' do
      expect {
        create(:blog, title_no: "", author_id: @member.id, image_id: @image.id)
      }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
```

The `before` block will create two objects, `member` and `image`, which can be used in all tests. The test above will create a `Blog` object using the factory method we created before, but set the Norwegian title to an empty string to trigger an exception. We expect in the test that this exception will be raised, which is of type `ActiveRecord::RecordInvalid`.

> We could do `create(:blog)`, which will use the default values of the attributes defined in `blog_factory`, but usually we want to override these attributes, say when we wan't to trigger an exception like above. Specifying the attributes above will override the default values.