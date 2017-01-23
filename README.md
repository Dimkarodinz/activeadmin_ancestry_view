# ActiveadminAncestryView
This gem allows to vizualize tree of [ancestry](https://github.com/stefankroes/ancestry) model in [ActiveAdmin](https://github.com/activeadmin/activeadmin) resource.

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
$ rails generate activeadmin_view_ancestry:install
```

## Model methods

In models with hide_ancestry:
```ruby
YourModel.first.full_ancestry     # same as #ancestry, but includes instance #id

YourModel.ordered_collection(ids) # return ActiveRecord::Relation in order equal to
                                  # ids order. If ids == [2,1,3], relation will be
                                  # sorted by id as [2,1,3] - not standart [1,2,3] way.

```

## TODO
+ Formastatic methods with options:
  - header_titles: []
  - table_titles: []
  - resource_collection: User.all
  - color: true
  - selectable: true
  - expandable: true
+ Add sort:
  - include methods to activeadmin resource:
    > ensure than 'contoller do...' still can be declared
+ Edit views to vizualize ANY resouce with ancestry
+ Add .gif to description 