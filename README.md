# ActiveadminAncestryView
This gem allows to vizualize tree of [Ancestry](https://github.com/stefankroes/ancestry) model in [ActiveAdmin](https://github.com/activeadmin/activeadmin) resource.

## Usage

*NOTE: Resource model should have has_ancestry.*

Add to you ActiveAdmin resource
```ruby
ActiveAdmin.register YourModel do

  ancestry_view(:index) do
    # Your optional code.
    # It will executed before rendering each template
  end

  ancestry_view(:show) do
    # Some not necessary code
  end
end
  
```

## Options

```ruby
# Same options available for ancestry_view(:show)
ancestry_view :index,
  headers: {
    title: :some_model_instance_method,
    info: 'Info',              # 'Info' link name
    expand: 'Expand',          # 'Expand' link name
    no_childless_link: true    # Hide link to resource#show for childless nodes
  },
  table: {
    'Name' => :first_name,     # Key - any string or symbol, value - model instance method
    :email => :email           # Table, as well as 'Info' and 'Expand' links,
                               # shows only if :table has values
  },
  shift_depth: 2 # In 'em'. Default is 4
  color:  true,  # TODO On/off colorize nodes. Default is true
```

## Model methods

Models with has_ancestry now have the following methods:
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

gem 'activeadmin_view_ancestry'
```

And then execute

```
$ bundle
```

To add required assets and concerns run
```
$ rails g activeadmin_view_ancestry:install
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

## TODO
+ redo templates (add tree lines)
+ update resource_collection after create new record/update (aa controller stuff)
+ isolate included AA module from rest of engine
+ Add .gif to description 