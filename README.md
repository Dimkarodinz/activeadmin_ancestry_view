# ActiveadminAncestryView
This gem allows to vizualize tree of [Ancestry](https://github.com/stefankroes/ancestry) model in [ActiveAdmin](https://github.com/activeadmin/activeadmin) resource.

<img src="./docs/images/resource_tree.gif"/>

## Usage

*NOTE: Resource model should have `has_ancestry`.*

Add to your ActiveAdmin resource
```ruby
ActiveAdmin.register YourModel do
  ancestry_view(:index) do
    # Some of your code for the 'index' view (optional).
    # It will been executed before templates rendering.
  end

  ancestry_view(:show) do
    # Some of your code for the 'show' view (optional).
    # It will been executed before templates rendering.
  end
end
  
```

## Options
Options - it's an extended version of `ancestry_views(:index)` or `ancestry_view(:show)`, actually just optional hash.
So please, try to include only *ONE* `ancestry_view` per action (*index* or *show*). Otherwise it will result in the error loop with "stack level too deep" message.

```ruby
# Same options available for ancestry_view(:show)
ancestry_view :index,
  headers: {
    title: :some_model_instance_method, # Node title link name
    info: 'Info',                       # 'Info' link name
    expand: 'Expand',                   # 'Expand' link name
  },
  table: {
    'Name' => :first_name,     # Key - any string or symbol, value - model instance method.
    :email => :email           # Table, as well as 'Info' and 'Expand' links,
  },                           # shows only if :table has some values.

  no_childless_link: true,     # Hide link to #show for childless nodes. Default is false
  no_color: true,              # On/off color nodes. Default is false
  shift_depth: 4               # In 'parrots'; looks fine if >= 3. Default is 4
```

## Model methods

```ruby
YourModel.first.full_ancestry     # Same as #ancestry, but includes instance id

YourModel.ordered_collection(ids) # Return ActiveRecord::Relation in order equal to
                                  # ids order. If ids equal to [2,1,3], relation will be
                                  # sorted as [2,1,3] agaist default [1,2,3] way.

```
## Installation

Add to your Gemfile

```ruby
gem 'activeadmin', github: 'activeadmin'
gem 'ancestry'

gem 'activeadmin_ancestry_view'
```

And then execute

```
$ bundle
```

For adding required assets and concerns please run
```
$ rails g activeadmin_ancestry_view:install
```

## Customization
For index resource you are still able to use `scoped_collection`.
For example, to not displaying nodes with depth > 2:

```ruby
ActiveAdmin.register SomeModel do
  ...
  controller do
    def scoped_collection
      resource_class.to_depth(2)
    end
  end
end
```

Also, you're able to change default locale setting. In `config/locales`:
```
uk:
  activeadmin_ancestry_view:
    expand: Розгорнути
    info: Інфо
    errors:
      wrong_action: "Не той екшн. Дозволені: %{actions}"
```
