module Types
  class EventType < BaseObject
    field :title, String, null: false
    field :age_limit, String, null: false
    field :status, String, null: false
    field :youtube_link, String, null: true
    field :twitter_link, String, null: true
    field :instagram_link, String, null: true
    field :organizer, GroupType, null: false


    field :longDescription, String, null: false do
      argument :language, String, required: false
    end
    def longDescription(language: "NO")
      "lol"
    end


    field :shortDescription, String, null: false do
      argument :language, String, required: false
    end
    def shortDescription(language: "NO")
      "LOL"
    end

    field :duration, Integer, null: false
  end
end
