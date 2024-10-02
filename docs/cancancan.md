# Can^3
We have decided to migrate from `declarative_authorization` to the `Can^3` gem for role-based authentication.


## Ability definitions
For simplicity, we have split the ability-definitions into separate classes. All of them are located in the `app/abilities` folder.

The main reason for doing this is so that none of the abilities granted in `ability.rb` can be accidentally applied to controllers in the `AdmissionsAdmin::` or `Sulten::` namespace.
It also makes it easier to debug and reason about why a given role has certain abilities.

For each role in our system we define a method. `guest`, `medlem` and `mg_gjengsjef` are three examples.
These methods are conditionally called in the `initialize(user)` on the ability object depending the properties of the `user` object.

The following block of code describes how methods are being called to assign permissions depending on the users role.
```ruby
@user.roles.each do |role|
  send(role.title) if respond_to? role.title
end
```
Furthermore it is important to note that the `:manage` permission is interpreted as a wildcard matching all actions (`:index, :show, :edit` and so forth).
Sor for safety *DO NOT* grant `:manage` privilges unless you are absolutely certain. Instead you should explicitly add each action like this

```ruby
can %i[index show], Event
```

## Controllers
Because `check_authorization` is called in `ApplicationController`, every controller of our system will disallow access if it is not explicitly given. This means that we have a secure by default approach.

Thus we have to either check permissions or skip the permission check explicitly in every controller.

#### Authorizing
Calling `load_and_authorize_resource` at the top of a controller class enables authorization for all its actions.
In addition it loads the given resource into an instance variables. An example follows
```ruby
class GroupsController < ApplicationController
  load_and_authorize_resource
  def show
    puts @group # @group is defined because of load_and_authorized_resource. @group = Group.find(params[:id])
  end
end
```

The way it authorizes is by calling `authorize! :action, Group` or `authorize! :action, @group` in every action depending on whether you are acting on a collection or a single object.

If you do not wish to load the resource, you can just call `authorize_resource` at the top of the controller instead.

For more information or clarification, see the [Can^3 documentation](https://github.com/CanCanCommunity/cancancan)

#### Skipping authorization
This is very easy, just call `skip_authorization_check` at the top of the controller class definition.

We're doing this in the `app/contollers/site_controller.rb`. We could also call `authorize_resource` and grant explicit privileges in `ability.rb`.


## Tips n trix
### Where is Can^3 being used to verify permissions in views or controllers?
#### Find all places where can? is being used
`grep -r 'can?[\(| ]:[a-z]*, [A-Z][A-Za-z]*[\)]*' app`

### rails console
The `rails console` is perhaps the best thing when working with Ruby on Rails. It is a great tool that allows you to debug almost anything.
For example, you can check the permissions of a given user like this

```ruby
user = Member.find(:id)
ability = Ability.new(user)
ability.permissions # prints the permissions for the ability
ability.can? :show, Admission # true/false
ablilty.can? :read, JobApplication.find(:id)

pp ability.permissions # This will beautifully print the ability permissions using pp (pretty print)
```
