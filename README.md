# ActiveadminAncestryView
This gem allows to vizualize tree of [Ancestry](https://github.com/stefankroes/ancestry) model in [ActiveAdmin](https://github.com/activeadmin/activeadmin) resource.

<img src="./docs/images/resource_tree.gif"/>

## Usage

*NOTE: Resource model should have `has_ancestry`.*

Add to you ActiveAdmin resource
```ruby
ActiveAdmin.register YourModel do
  ancestry_view(:index) do
    # Your optional code.
    # It will executed before templates rendering
  end

  ancestry_view(:show) do
    # Some your optional code
  end
end
  
```

## Options

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
  },                           # shows only if :table has values.

  no_childless_link: true,     # Hide link to #show for childless nodes. Default is false
  no_color: true,              # On/off color nodes. Default is false
  shift_depth: 4               # In 'parrots'; looks good if >= 3. Default is 4
```

## Model methods

```ruby
YourModel.first.full_ancestry     # Same as #ancestry, but includes instance id

YourModel.ordered_collection(ids) # Return ActiveRecord::Relation in order equal to
                                  # ids order. If ids equal to [2,1,3], relation will be
                                  # sorted as [2,1,3] agaist standart [1,2,3] way.

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

To add required assets and concerns run
```
$ rails g activeadmin_ancestry_view:install
```

## Customization
For index resource you are still able to use `scoped_collection`.
For example, to not displaying too deep nodes:

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
It will hide nodes with depth > 2.

Also, you can change default locale setting. In `config/locales`:
```
uk:
  activeadmin_ancestry_view:
    expand: Розгорнути
    info: Інфо
    errors:
      wrong_action: "Не той екшн. Дозволені: %{actions}"
```