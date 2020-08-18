# 🆕 Use Plugins

?> Starting from `v0.4.0`, you can use plugins.  

You can use plug-ins to transform the API documentation.  
You can also modify parameters or change the component schema name at once.

The possibilities are endless, depending on your ideas. 🤗

## Support Type

| type      | description                         |
| --------- | ----------------------------------- |
| Transform | You can transform the API documentation |

## Usage

### Create plugin file

Create a file called `oas_docs/plugins/sample_transform.rb`

```ruby
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

    external_document do |doc|
      # [Important] Make destructive changes to the doc
      doc.merge!({
        title: 'override title'
      })
    end

    path_item do |doc, ref|
      # [Important] Make destructive changes to the doc
      #
      # ref is the following object:
      # 
      # e.g.)
      # ref = {
      #  type: :path_item,
      #  path: '/api/v1/task/{id}'
      # }
    end

    components_schema do |doc, ref|
      # [Important] Make destructive changes to the doc
      #
      # ref is the following object:
      # 
      # e.g.)
      # ref = {
      #  type: :schema,   
      #  path: '/api/v1/task/{id}',
      #  schema_name: 'api.v1.Task',
      #  tag_name: 'api/v1/task',
      #  verb: 'GET',
      #  http_status: 200,
      #  from: :path_item (:request_body or :schema),
      #  parent_schema_name: 'api.v1.ParentTask',
      #  depth: 1
      # }
    end

    components_request_body do |doc, ref|
      # [Important] Make destructive changes to the doc
      #
      # ref is the following object:
      #
      # e.g.)
      # ref = {
      #  type: :request_body,
      #  path: '/api/v1/task/{id}', 
      #  schema_name: 'api.v1.Task',
      #  tag_name: 'api/v1/task',
      #  verb: 'PUT',
      #  from: :path_item,
      #  parent_schema_name: 'api.v1.ParentTask',
      #  depth: 1
      # }
    end

    components_schema_name do |ref|
      # [Important] Set a new value for ref[:schema_name] or ref.schema_name
      #
      # ref is the following object:
      # 
      # e.g.)
      # ref = { 
      #  type: :schema,
      #  path: '/api/v1/task/{id}',
      #  schema_name: 'api.v1.Task',
      #  tag_name: 'api/v1/task',
      #  verb: 'GET',
      #  http_status: 200,
      #  from: :schema (:request_body),
      #  parent_schema_name: 'api.v1.ParentTask',
      #  depth: 1
      # }
      #
      # e.g.)
      if opts[:override]
        case ref.from
        when :path_item
          ref[:schema_name] = 'new component schema name'
          break;
        when :request_body
          ref.schema_name = 'new component schema name'
          break;
        when :schema
          ref[:schema_name] = 'new component schema name'
          break;
        end
      end
    end

    components_request_body_name do |ref|
      # [Important] Set a new value for ref[:schema_name] or ref.schema_name
      #
      # ref is the following object:
      # 
      # e.g.)
      # ref = {
      #  type: :request_body, 
      #  path: '/api/v1/task/{id}',
      #  schema_name: 'api.v1.Task',
      #  tag_name: 'api/v1/task',
      #  verb: 'PATCH',
      #  from: :path_item,
      #  parent_schema_name: 'api.v1.ParentTask',
      #  depth: 0
      # }
      #
      # e.g.)
      ref[:schema_name] = 'new component schema name'
    end
  end
end
```

?> ・ In the case of the Transform plugin, be sure to inherit the `R2OAS::Plugin::Transform`  
   ・There are no rules for plugin names, but you can name them something easy to understand,
     like it is recommended to use the format `r2oas-plugin-transform-<your_plugin_name>`

### Load plugin

Set to load the plugin in R2OAS

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

The plugin will be applied at build time. There is no effect on the `src files`.

```bash
$ bundle exec rake routes:oas:build
```

Please confirm the difference of the file whether it was converted as expected. 🤗

The result of applying the plugin is output to `oas_docs/dist/oas_doc.yml` by default

### Execute plugin for src files

If you want to apply the plugin directly to src files instead of just build artifacts,  
Set the `OVERRIDE_SRC` environment variable to `true`.

```bash
$ OVERRIDE_SRC=true bundle exec rake routes:oas:build
```

!> If the applied plugin is not idempotent, the converted data may be unexpected.

### Skip plugin apply

In case you don't want to apply the plugin when building the documentation,  
Please set the environment variable `SKIP_PLUGIN` to `true`.

```bash
$ SKIP_PLUGIN=true bundle exec rake routes:oas:build
```

## Important

!> Be sure to write the plugin so that it is idempotent.  

For example, don't write a plugin that translates component schema names like this:

```ruby
components_schema_name do |ref|
  ref[:schema_name] = ref[:schema_name] + "something"
end
```

If you overwrite the `src files`, the schema name will be changed each time you execute it and idempotency will be lost

## API

The plugin has the following API.

|name|description|remark|
|----|-----------|------|
|plugin_name|Name of plugin|It is recommended to name from the prefix of `r2oas-plugin-transform-`|
|setup|Sets the default value for `opts`.|`opts` can also be referenced by other blocks.|
|teardown|Called after the plugin has been applied to the API documentation. If there is post-processing, write it here.||
|info|You can transform `info`|`Make breaking changes to doc`|
|external_document|You can transform `externalDocs`|`Make breaking changes to doc`|
|path_item|You can transform `path item`|`Make breaking changes to doc`|
|components_schema|You can transform `item of components/schemas`|`Make breaking changes to doc`|
|components_request_body|You can transform `item of components/requestBodies`|`Make breaking changes to doc`|
|components_schema_name|You can transform `item name of components/schemas`|`Substitute a value for ref[:schema_name]`|
|components_request_body_name|You can transform `item name of components/requestBodies`|`Substitute a value for ref[:schema_name]`|


## ref


`ref` can be instances of three classes  
There is no ref for `setup・teardown・info・external_document`  

- PathRef
- Components::SchemaRef
- Components::RequestBodyRef

The methods that can be called respectively are as follows

### PathRef methods

```bash
[1] pry> ls ref
R2OAS::Schema::V3::FromFiles::BaseRef#methods: []  []=  parent  pretty_print  to_h
R2OAS::Schema::V3::FromFiles::PathRef#methods: path  type
instance variables: @path  @type
```

### Components::SchemaRef methods

Only `schema_name` can be rewritten with `ref.schema_name=` or `ref[:schema_name]=`

```bash
[1] pry> ls ref
R2OAS::Schema::V3::FromFiles::BaseRef#methods: []  []=  parent  pretty_print  to_h
R2OAS::Schema::V3::FromFiles::Components::SchemaRef#methods: depth  from  http_status  parent_schema_name  path  schema_name  schema_name=  tag_name  type  verb
instance variables: @depth  @from  @http_status  @parent  @parent_schema_name  @path  @schema_name  @tag_name  @type  @verb
```

### Components::RequestBodyRef methods

Only `schema_name` can be rewritten with `ref.schema_name=` or `ref[:schema_name]=`

```bash
[1] pry> ls ref
R2OAS::Schema::V3::FromFiles::BaseRef#methods: []  []=  parent  pretty_print  to_h
R2OAS::Schema::V3::FromFiles::Components::RequestBodyRef#methods: depth  from  parent_schema_name  path  schema_name  schema_name=  tag_name  type  verb
instance variables: @depth  @from  @parent  @parent_schema_name  @path  @schema_name  @tag_name  @type  @verb
```


|block name|ref class|remark|
|----------|--------|------|
|path_item|`PathRef`||
|components_schema|`Components::SchemaRef`|`from` is set to one of `:path_item`, `:request_body`, `:schema`|
|components_schema_name|`Components::SchemaRef`|`from` is set to one of `:path_item`, `:request_body`, `:schema`|
|components_request_body|`Components::RequestBodyRef`|`from` is set one of `:path_item`|
|components_request_body_name|`Components::RequestBodyRef`|`from` is set one of `:path_item`|

- `type` is the type of `ref`
- `from` indicates where the schema is referenced from  
- `depth` is the depth of the components schema(requestBody)  

If you want to know the `ref of the parent schema` using the schema, call `ref.parent`  
e.g.) `ref.parent`, `ref.parent.parent.parent`

If you want to convert it to Hash, call `to_h`  
e.g.) `ref.to_h`
