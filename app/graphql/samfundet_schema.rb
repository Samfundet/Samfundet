# frozen_string_literal: true

class SamfundetSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  def self.resolve_type(abstract_type, object, context)
    if object.is_a?(Group)
      Types::GroupType
    elsif object.is_a?(ExternalOrganizer)
      Types::ExternalOrganizerType
    else
      nil
    end
  end
end
