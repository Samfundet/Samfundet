# frozen_string_literal: true

class SamfundetSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  def self.resolve_type(_abstract_type, object, _context)
    if object.is_a?(Group)
      Types::GroupType
    elsif object.is_a?(ExternalOrganizer)
      Types::ExternalOrganizerType
    end
    nil
  end
end
