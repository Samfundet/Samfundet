# frozen_string_literal: true

class Mutations::Authenticate < GraphQL::Schema::Mutation
  null true
  argument :email, String, required: true
  argument :password, String, required: true

  field :success, Boolean, null: false
  field :current_user, Types::MemberType, null: true

  def resolve(email:, password:)
    member = Member.authenticate(email, password)

    puts member
    if member.nil?
      {
        success: false
      }
    else
      context[:member_id] = member.id
      {
        current_user: member,
        success: true
      }
    end
  end
end
