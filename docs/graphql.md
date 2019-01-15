# Samfundet + GraphQL = <3

## Introduction
The next version of Samfundet will have a server-client architecture, meaning that the Ruby-on-Rails (RoR) part of the project will only act as an API providing data to clients. The primary client will be the web client written in TypeScript and React. It can be found in the `Samfundet/Samfundet-react` repository.

For the API implementation we have decided to go with GraphQL for various reasons.

Here is the official [introduction to GraphQL](https://graphql.org/learn/).
For more information on how to use GraphQL with Ruby-on-Rails, see [here](https://vitobotta.com/2018/06/13/using-graphql-with-rails/). Keep in mind that the syntax might be outdated or different from exactly what we're doing.

## How it works
Assuming that you are somewhat familiar with GraphQL after skimming through the resources listed above, I will try to explain how it all works.

First of all, we have to define GraphQL types for everything we want to make available through the API.
Examples of these types are `Event`, `BlogPost` or `Group`.

Each of these types can be considered as mappings to a Ruby-on-Rails model. So the GraphQL `Event`-type corresponds more or less with the Ruby-on-Rails `Event` model.

`app/models/event.rb` => `app/graphql/types/event_type.rb`

The GraphQL-type decides what data from the Rails `Event`-model is made available through the GraphQL API.

Here is a very basic example of a GraphQL `Event`-type.
```ruby
module Types
  class EventType < Bases::BaseObject
    field :titleEn, String, null: false
  end
end
```

GraphQL schemas usually have two root-types, namely `Query` and `Mutation`. The fields of these types can be considered the *endpoints* of the API.

Finally, to actually get the events, an "endpoint" has to be added. This is done by adding a field to the top-level GraphQL `Query`-type.

```ruby
module Queries
  class QueryType < Types::Bases::BaseObject
    field :events, Types::EventType, null: false do
      description 'Get events.'
    end

    def events
      Event.all
    end
  end
end
```
This file can be found at `app/graphql/queries/query_type.rb`

Here we can see that Rails `Event` objects are implicitly mapped to the GraphQL `EventType`!

An example query that would work with this setup
```graphql
query getEvents {
  events {
    titleEn
  }
}
```

## Things to do
### Authorization
For more information on how to handle authorization with `graphql-ruby`, see [the official documentation](http://graphql-ruby.org/authorization/overview.html).

#### User authentication
[Token-based Authentication with Ruby on Rails 5 API](https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api)
#### Roles / access restriction
[Pundit](https://github.com/varvet/pundit) or [CanCanCan](https://github.com/CanCanCommunity/cancancan)

Both of the above can be integreated into.
[graphql-guard: Field-level authorization](https://github.com/exAspArk/graphql-guard)

#### Visibility
To prevent users from seeing the admin-parts of our GraphQL schema, we can hide stuff depending on the current user.

See [here](http://graphql-ruby.org/authorization/visibility.html) for more information.

### Performance
#### Caching
[Resolver level caching](https://stackshare.io/posts/introducing-graphql-cache)

#### Batching
[Batching – A powerful way to solve N+1 queries every Rubyist should know](https://engineering.universe.com/batching-a-powerful-way-to-solve-n-1-queries-every-rubyist-should-know-24e20c6e7b94)

[Shopify/graphql-batch](https://github.com/Shopify/graphql-batch)

