module Types
  class EventType < BaseObject
    field :title, String, null: false


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
