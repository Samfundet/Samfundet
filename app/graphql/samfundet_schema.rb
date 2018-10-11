# frozen_string_literal: true

class SamfundetSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
