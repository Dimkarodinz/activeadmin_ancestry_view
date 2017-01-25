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

*NOTE: Resource model should have has_ancestry in it*
Add to you ActiveAdmin resource
```ruby
ActiveAdmin.register YourModel do

  ancestry_view(:index) do
    # Your optional code.
    # It will be evaluated before template rendering
  end

  ancestry_view(:show) do
    # Some not necessary code
  end

end
  
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
+ do it more OOP
+ ancestry_view options:
  - header_titles: []
  - table_titles: []
  - resource_collection: User.all
  - color: true
  - selectable: true
  - expandable: true
+ Edit views to vizualize ANY resouce with ancestry (resource_path ?)
+ Add generator to rendering views and assets
+ Add .gif to description 