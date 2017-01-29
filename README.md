# ActiveadminAncestryView
This gem allows to vizualize tree of [Ancestry](https://github.com/stefankroes/ancestry) model in [ActiveAdmin](https://github.com/activeadmin/activeadmin) resource.

+ TODO: add .gif here

## Usage

*NOTE: Resource model should have has_ancestry.*

Add to you ActiveAdmin resource
```ruby
ActiveAdmin.register YourModel do

  ancestry_view(:index) do
    # Your optional code.
    # It will executed before templates rendering
  end

  ancestry_view(:show) do
    # Some not so necessary code
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
  },                           # shows only if :table has some data in it.
                               #
  no_childless_link: true,     # Hide link to #show for childless nodes. Default is false
  no_color: true,              # On/off color nodes. Default is false
  shift_depth: 2               # In 'em'. Default is 4
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

## Additional

You can change default locale setting. In `config/locales`:
```
uk:
  activeadmin_ancestry_view:
    expand: Розгорнути
    info: Інфо
    errors:
      wrong_action: "Не той екшн. Дозволені: %{actions}"
```