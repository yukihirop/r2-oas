# 🆕 Use Plugins

Starting from v0.4.0, you can use plugins.  
This plugin can be used just like `babel-plugin-transform`.

You can use plug-ins to transform the API documentation.  
You can also modify parameters or change the component schema name at once.

The possibilities are endless, depending on your ideas. 🤗

## Support Plugins

| type      | description                         |
| --------- | ----------------------------------- |
| Transform | You can transform the API documentation |

## Usage

### Create plugin file

Create a file called `oas_docs/plugins/sample_transform.rb`

```rb
# frozen_string_literal: true

module YourNamespace
  class SampleTransform < R2OAS::Plugin::Transform
    self.plugin_name = 'r2oas-plugin-transform-sample'

    setup do
      # Initialize here if you want to pass opts
      # Can be referenced in other blocks with opts
      # e.g.)
      self.opts = { override: false }
    end

    teardown do
      # If you need to post-process the API documentation after it has been generated, you can do so here
    end

    info do |doc|
      # [Important] Make destructive changes to the doc
      # e.g.)
      doc.merge!({
        title: 'override title'
      })
    end

    path_item do |doc, path|
      # [Important] Make destructive changes to the doc
    end

    components_schema do |doc, schema_name|
      # [Important] Make destructive changes to the doc
    end

    components_request_body do |doc, schema_name|
      # [Important] Make destructive changes to the doc
    end

    components_schema_name do |ref, doc, path_component, tag_name, verb, http_status|
      # [Important] Set a new value for ref[:schema_name]
      # e.g.)
      if opts[:override]
        ref[:schema_name] = 'new component schema name'
      end
    end

    components_request_body_name do |ref, doc, path_component, tag_name, verb|
      # [Important] Set a new value for ref[:schema_name]
      # e.g.)
      ref[:schema_name] = 'new component schema name'
    end

    components_schema_name_at_request_body do |ref, doc, path_component, tag_name, verb|
      # [Important] Set a new value for ref[:schema_name]
      # e.g.)
      ref[:schema_name] = 'new component schema name'
    end
  end
end
```

?> ・ In the case of the Transform plugin, be sure to inherit the `R2OAS::Plugin::Transform`  
   ・There are no rules for plugin names, but you can name them something easy to understand,
     like it is recommended to use the format `r2oas-plugin-transform-<your_plugin_name>`

`path_component` is `R2OAS::Routing::PathComponent` instance.

```rb
module R2OAS
  module Routing
    class PathComponent < BaseComponent
      def to_s
      def symbol_to_brace
      def path_parameters_data
      def path_excluded_path_parameters
      def exist_path_parameters?
      def path_parameters
      private
      def without_format
```

### Load plugin

Set to load the plugin in R2OAS and finish

```rb
R2OAS.configure do |config|
  config.plugins = [
    # If you want to override opts, pass it as the second argument
    ['r2oas-plugin-transform-sample', { override: true }],
    # If you do not need to set options, pass only a string
    'r2oas-plugin-transform-sample-2'
  ]
end
```

### Execute plugin

There are dedicated commands for applying plugins.

```bash
$ bundle exec rake routes:oas:plugin
```

Please confirm the difference of the file whether it was converted as expected. 🤗
