# ActiveadminAncestryView
This gem allows to vizualize tree of [Ancestry](https://github.com/stefankroes/ancestry) model in [ActiveAdmin](https://github.com/activeadmin/activeadmin) resource.

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

## Usage

*NOTE: Resource model should have has_ancestry in it.*

Add to you ActiveAdmin resource
```ruby
ActiveAdmin.register YourModel do
  ancestry_view(:index) do
    # Your optional code.
    # It will executed before rendering of each template
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
  headers: { title: :some_model_instance_method,
             info: 'Info',
             expand: 'Expand',
             link_to_show: 'Open'},
  table: {'Name' => :first_name, :email => :email}, # key - general name; value - model instance method
  color: true,  # TODO
  select: true, # TODO Change color of subtree on click
  expand: true  # TODO Show 'Expand' and 'Info' on node template
```

## Model methods

Models with has_ancestry now have the following methods:
```ruby
YourModel.first.full_ancestry     # Same as #ancestry, but includes instance #id

YourModel.ordered_collection(ids) # Return ActiveRecord::Relation in order equal to
                                  # ids order. If ids == [2,1,3], relation will be
                                  # sorted by id as [2,1,3] agaist standart [1,2,3]-way.

```

## TODO
+ redo templates
+ Add namespace to I18n
+ isolate included AA module from rest of engine
+ Add generator to rendering views and assets
+ Add .gif to description 