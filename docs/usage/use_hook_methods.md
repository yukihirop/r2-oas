# Use hook methods

Supported hook(life cycle methods) is like this:

- `before_create`
- `after_create`

Supported Hook class is like this:

- `R2OAS::Schema::V3::InfoObject`
- `R2OAS::Schema::V3::PathsObject`
- `R2OAS::Schema::V3::PathItemObject`
- `R2OAS::Schema::V3::ExternalDocumentObject`
- `R2OAS::Schema::V3::ComponentsObject`
- `R2OAS::Schema::V3::Components::SchemaObject`
- `R2OAS::Schema::V3::Components::RequestBodyObject`

By inheriting these classes, you can hook them at the time of document generation by writing like this:

#### case: InfoObject

```ruby
class CustomInfoObject < R2OAS::Schema::V3::InfoObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, path|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: PathsObject

```ruby
class CustomPathsObject < R2OAS::Schema::V3::PathsObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: PathItemObject

```ruby
class CustomPathItemObject < R2OAS::Schema::V3::PathItemObject
  before_create do |doc, path|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: ExternalDocumentObject

```ruby
class CustomExternalDocumentObject < R2OAS::Schema::V3::ExternalDocumentObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: ComponentsObject

```ruby
class CustomComponentsObject < R2OAS::Schema::V3::ComponentsObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: Components::SchemaObject

```ruby
class CustomComponentsSchemaObject < R2OAS::Schema::V3::Components::SchemaObject
  before_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

If you want to determine the component schema name at runtime, like this:

```ruby
class CustomComponentsSchemaObject < R2OAS::Schema::V3::Components::SchemaObject
  def components_schema_name(doc, path_component, tag_name, verb, http_status, schema_name)
    # [Important] Please return string.
    # default
    schema_name
  end
end
```

`path_component` is `R2OAS::Routing::PathComponent` instance.

```ruby
module R2OAS
  module Routing
    class PathComponent < BaseComponent
      def initialize(path)
      def to_s
      def symbol_to_brace
      def path_parameters_data
      def path_excluded_path_parameters
      def exist_path_parameters?
      def path_parameters
      private
      def without_format
```

#### case: Components::RequestBodyObject

```ruby
class CustomComponentsRequestBodyObject < R2OAS::Schema::V3::Components::RequestBodyObject
  before_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

If you want to determine the component schema name at runtime, like this:

```ruby
class CustomComponentsRequestBodyObject < R2OAS::Schema::V3::Components::RequestBodyObject
  def components_request_body_name(doc, path_component, tag_name, verb, schema_name)
    # [Important] Please return string.
    # default
    schema_name
  end

  def components_schema_name(doc, path_component, tag_name, verb, schema_name)
    # [Important] Please return string.
    # default
    schema_name
  end
end
```

And write this to the configuration.

```ruby
# If only InfoObject and PathItemObject, use a custom class
R2OAS.configure do |config|
  # 
  # omission ...
  # 
  config.use_object_classes.merge!({
    info_object:      CustomInfoObject,
    path_item_object: CustomPathItemObject
  })
end
```

This is the end.
