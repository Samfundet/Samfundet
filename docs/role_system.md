# Samfundets role system
## Overview
The role system of Samfundet.no is used grant permissions to our members, allowing them access to various features of Samfundet.no depending on the various roles they hold.

The permissions of each role depends on what type of role it is. Access is enforced using `CanCanCan` (Can^3) abilities, all of which are defined in the `app/abilities` folder.

## Role model
No pun intended. The `Role` model is defined by `app/models/role.rb` and is merged with the `Role` model from the `Samfundet/SamfundetAuth` repository.
`SamfundetAuth` is imported into the `Samfundet`-project as a dependency (gem) and included in `role.rb` like this:
```ruby
require SamfundetAuth::Engine.root.join('app', 'models', 'role')
```

I'm not sure of the exact reason it is implemented in this way, but I can imagine that they wanted to enforce some longevity on the role system by placing parts of the model in another repository.
We should ask our pangs about this.

A `Role` has these fields:
```ruby
Role(
  id: integer,
  name: string,
  title: string,
  description: text,
  show_in_hierarchy: boolean,
  role_id: integer,
  group_id: integer,
  created_at: datetime,
  updated_at: datetime,
  passable: boolean
)
```

More information about how it is represented in the database can be found in `db/schema.rb`. Information about relations and data validation can be found in `app/models/role.rb` and in `role.rb` in the `SamfundetAuth` repository.

## Relations
Most `Role`s belongs to a `Group` defined by `Role.group_id`. To get the associated `Group`-object you can just call `.group` on a `Role` like this:
```ruby
role = Role.find(:id)
role.group_id # id of the associated group
role.group # the group associated with the role
```


A `Role` can have a parent role. Unintuitively it can be fetched like this:

```ruby
child_role = Role.find(:id) # :id = id of a child role
child_role.role # the parent role of child_role
```

Because a `Role` can have a parent, these parents `Role`s must have children. Getting the children of a `Role` can be done like this
```ruby
parent_role = Role.find(:id) # id of a parent role
parent_role.roles # the children of parent_roleTo get the children of a role


# To fetch all roles has no parent, you can do this
no_parents = Role.where(role_id: nil)
no_parents.first.roles # will list the children of the first role with no parent. Might be an empty list if the list has no children
```
