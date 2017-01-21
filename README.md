# ActiveadminAncestryView
This gem allows to vizualize [ancestry](https://github.com/stefankroes/ancestry) subtree in [ActiveAdmin](https://github.com/activeadmin/activeadmin) resource.

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

To install activeadmin_view_ancestry assets run
```
$ rails generate activeadmin_view_ancestry:install
```

## TODO
+ Formastatic methods with options:
  - header_titles: []
  - table_titles: []
  - resource_collection: User.all
  - color: true
  - selectable: true
  - expandable: true
+ Add sort by ancestry
+ ? AA resource methods
+ Add .gif to description 