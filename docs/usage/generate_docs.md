# Generate docs

## Prepare

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'r2-oas'
end
```

## Command

```bash
$ bundle exec rake routes:oas:docs
```

## Example

if there is routing like this:


[config/routes.rb]
```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v2 do
      resources :posts
    end
  end
  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
```

#### First try

```
$ bundle exec rake routes:oas:docs
I, [2020-05-01T00:26:30.037255 #32948]  INFO -- : [R2-OAS] start
I, [2020-05-01T00:26:30.672796 #32948]  INFO -- : [Generate OAS schema files] start
I, [2020-05-01T00:26:30.672844 #32948]  INFO -- : <From routes data>
I, [2020-05-01T00:26:30.672860 #32948]  INFO -- : <Update schema files>
I, [2020-05-01T00:26:30.674709 #32948]  INFO -- :  Add schema file into store: 	oas_docs/src/openapi.yml
I, [2020-05-01T00:26:30.677510 #32948]  INFO -- :  Add schema file into store: 	oas_docs/src/info.yml
I, [2020-05-01T00:26:30.679245 #32948]  INFO -- :  Add schema file into store: 	oas_docs/src/tags.yml
I, [2020-05-01T00:26:30.679266 #32948]  INFO -- :  [Generate OAS schema files (paths)] start
I, [2020-05-01T00:26:30.733419 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:30.733458 #32948]  INFO -- :  <Update schema files (paths)>
I, [2020-05-01T00:26:30.739675 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v1/task.yml
I, [2020-05-01T00:26:30.746521 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v2/post.yml
I, [2020-05-01T00:26:30.748522 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/blob.yml
I, [2020-05-01T00:26:30.750825 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/direct_upload.yml
I, [2020-05-01T00:26:30.753929 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/disk.yml
I, [2020-05-01T00:26:30.755903 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/representation.yml
I, [2020-05-01T00:26:30.761207 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/user.yml
I, [2020-05-01T00:26:30.761230 #32948]  INFO -- :  [Generate OAS schema files (paths)] end
I, [2020-05-01T00:26:30.762215 #32948]  INFO -- :  Add schema file into store: 	oas_docs/src/external_docs.yml
I, [2020-05-01T00:26:30.763149 #32948]  INFO -- :  Add schema file into store: 	oas_docs/src/servers.yml
I, [2020-05-01T00:26:30.763188 #32948]  INFO -- :  [Generate OAS schema files (components)] start
I, [2020-05-01T00:26:30.866904 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:30.866941 #32948]  INFO -- :  <Update Components schema files (components/schemas)>
I, [2020-05-01T00:26:30.868176 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T00:26:30.869116 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/blob.yml
I, [2020-05-01T00:26:30.870156 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T00:26:30.871289 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T00:26:30.872316 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/representation.yml
I, [2020-05-01T00:26:30.873301 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T00:26:30.874282 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T00:26:30.925057 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:30.925096 #32948]  INFO -- :  <Update Components schema files (components/requestBodies)>
I, [2020-05-01T00:26:30.927746 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T00:26:30.929966 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T00:26:30.932245 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T00:26:30.934686 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T00:26:30.937036 #32948]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T00:26:30.994492 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:30.994534 #32948]  INFO -- :  <Update Components schema files (components/securitySchemes)>
I, [2020-05-01T00:26:31.057864 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:31.057907 #32948]  INFO -- :  <Update Components schema files (components/parameters)>
I, [2020-05-01T00:26:31.112288 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:31.112324 #32948]  INFO -- :  <Update Components schema files (components/responses)>
I, [2020-05-01T00:26:31.168867 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:31.168905 #32948]  INFO -- :  <Update Components schema files (components/examples)>
I, [2020-05-01T00:26:31.221234 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:31.221311 #32948]  INFO -- :  <Update Components schema files (components/headers)>
I, [2020-05-01T00:26:31.278310 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:31.278346 #32948]  INFO -- :  <Update Components schema files (components/links)>
I, [2020-05-01T00:26:31.332940 #32948]  INFO -- :  <From routes data>
I, [2020-05-01T00:26:31.333018 #32948]  INFO -- :  <Update Components schema files (components/callbacks)>
I, [2020-05-01T00:26:31.333037 #32948]  INFO -- :  [Generate OAS schema files (components)] end
I, [2020-05-01T00:26:31.335576 #32948]  INFO -- : [Generate OAS docs] Update cache at ./oas_docs/.docs
I, [2020-05-01T00:26:31.335616 #32948]  INFO -- : [Generate OAS schema files] end
I, [2020-05-01T00:26:31.335634 #32948]  INFO -- : [R2-OAS] end
```

Generate like this:

```
$ tree -a oas_docs
oas_docs
├── .docs
├── .paths
└── src
    ├── components
    │   ├── requestBodies
    │   │   ├── activestorage
    │   │   │   ├── direct_upload.yml
    │   │   │   └── disk.yml
    │   │   ├── api
    │   │   │   ├── v1
    │   │   │   │   └── task.yml
    │   │   │   └── v2
    │   │   │       └── post.yml
    │   │   └── user.yml
    │   └── schemas
    │       ├── activestorage
    │       │   ├── blob.yml
    │       │   ├── direct_upload.yml
    │       │   ├── disk.yml
    │       │   └── representation.yml
    │       ├── api
    │       │   ├── v1
    │       │   │   └── task.yml
    │       │   └── v2
    │       │       └── post.yml
    │       └── user.yml
    ├── external_docs.yml
    ├── info.yml
    ├── openapi.yml
    ├── paths
    │   ├── active_storage
    │   │   ├── blob.yml
    │   │   ├── direct_upload.yml
    │   │   ├── disk.yml
    │   │   └── representation.yml
    │   ├── api
    │   │   ├── v1
    │   │   │   └── task.yml
    │   │   └── v2
    │   │       └── post.yml
    │   └── user.yml
    ├── servers.yml
    └── tags.yml

17 directories, 26 files
```

#### Second Try (Change routes)

If routing changes like this:

```diff
Rails.application.routes.draw do
  namespace :api do
    namespace :v2 do
      resources :posts
    end
  end
  namespace :api do
    namespace :v1 do
+      resources :tasks, only: [:index, :create]
-      resources :tasks
    end
  end
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
```

When the `bundle exec rake routes:oas:docs` command is executed in this state, it becomes as follows:

```
I, [2020-05-01T01:06:35.982655 #34660]  INFO -- : [R2-OAS] start
I, [2020-05-01T01:06:36.508949 #34660]  INFO -- : [Generate OAS schema files] start
I, [2020-05-01T01:06:36.509027 #34660]  INFO -- : <From routes data>
I, [2020-05-01T01:06:36.509053 #34660]  INFO -- : <Update schema files>
I, [2020-05-01T01:06:36.511900 #34660]  INFO -- :  Add schema file into store: 	oas_docs/src/openapi.yml
I, [2020-05-01T01:06:36.513213 #34660]  INFO -- :  Add schema file into store: 	oas_docs/src/info.yml
I, [2020-05-01T01:06:36.515045 #34660]  INFO -- :  Add schema file into store: 	oas_docs/src/tags.yml
I, [2020-05-01T01:06:36.515066 #34660]  INFO -- :  [Generate OAS schema files (paths)] start
I, [2020-05-01T01:06:36.572245 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:36.572281 #34660]  INFO -- :  <Update schema files (paths)>
I, [2020-05-01T01:06:36.574396 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v1/task.yml
I, [2020-05-01T01:06:36.580388 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v2/post.yml
I, [2020-05-01T01:06:36.582187 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/blob.yml
I, [2020-05-01T01:06:36.583721 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/direct_upload.yml
I, [2020-05-01T01:06:36.585989 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/disk.yml
I, [2020-05-01T01:06:36.588352 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/representation.yml
I, [2020-05-01T01:06:36.594436 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/user.yml
I, [2020-05-01T01:06:36.594470 #34660]  INFO -- :  [Generate OAS schema files (paths)] end
I, [2020-05-01T01:06:36.595590 #34660]  INFO -- :  Add schema file into store: 	oas_docs/src/external_docs.yml
I, [2020-05-01T01:06:36.596515 #34660]  INFO -- :  Add schema file into store: 	oas_docs/src/servers.yml
I, [2020-05-01T01:06:36.596534 #34660]  INFO -- :  [Generate OAS schema files (components)] start
I, [2020-05-01T01:06:36.717794 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:36.717835 #34660]  INFO -- :  <Update Components schema files (components/schemas)>
I, [2020-05-01T01:06:36.718962 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T01:06:36.719937 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/blob.yml
I, [2020-05-01T01:06:36.720934 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T01:06:36.722095 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T01:06:36.723164 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/representation.yml
I, [2020-05-01T01:06:36.724655 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T01:06:36.725850 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T01:06:36.777317 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:36.777355 #34660]  INFO -- :  <Update Components schema files (components/requestBodies)>
I, [2020-05-01T01:06:36.779647 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T01:06:36.782242 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T01:06:36.784386 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T01:06:36.786612 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T01:06:36.788868 #34660]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T01:06:36.841673 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:36.841712 #34660]  INFO -- :  <Update Components schema files (components/securitySchemes)>
I, [2020-05-01T01:06:36.893801 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:36.893842 #34660]  INFO -- :  <Update Components schema files (components/parameters)>
I, [2020-05-01T01:06:36.948128 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:36.948166 #34660]  INFO -- :  <Update Components schema files (components/responses)>
I, [2020-05-01T01:06:37.000992 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:37.001030 #34660]  INFO -- :  <Update Components schema files (components/examples)>
I, [2020-05-01T01:06:37.053304 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:37.053342 #34660]  INFO -- :  <Update Components schema files (components/headers)>
I, [2020-05-01T01:06:37.109044 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:37.109082 #34660]  INFO -- :  <Update Components schema files (components/links)>
I, [2020-05-01T01:06:37.159305 #34660]  INFO -- :  <From routes data>
I, [2020-05-01T01:06:37.159343 #34660]  INFO -- :  <Update Components schema files (components/callbacks)>
I, [2020-05-01T01:06:37.159354 #34660]  INFO -- :  [Generate OAS schema files (components)] end
I, [2020-05-01T01:06:37.160924 #34660]  INFO -- :   Delete schema file: 	oas_docs/src/paths/api/v1/task.yml
I, [2020-05-01T01:06:37.161753 #34660]  INFO -- :   Write schema file: 	oas_docs/src/paths/api/v1/task.yml
I, [2020-05-01T01:06:37.162357 #34660]  INFO -- : [Generate OAS docs] Update cache at ./oas_docs/.docs
I, [2020-05-01T01:06:37.162374 #34660]  INFO -- : [Generate OAS schema files] end
I, [2020-05-01T01:06:37.162386 #34660]  INFO -- : [R2-OAS] end
```

The file is updated by the route deleted in this way. The behavior will be the same when adding.

## Create Cache Docs [Important]

It is a function of `v0.1.4` or later that the `.docs` file is generated when the `bundle exec rake routes:oas:docs` command is executed, so those who have used it before that need to hit the following command to create the` .docs` file.

```bash
CACHE_DOCS=true bundle exec rake routes:oas:docs
```

Create the cache information of API document with reference to the current information of `config/routes.rb`. Files under `src/**/**.yml` are not affected

<details>

```
$ CACHE_DOCS=true bundle exec rake routes:oas:docs
I, [2020-05-01T01:31:23.512339 #38857]  INFO -- : [R2-OAS] start
I, [2020-05-01T01:31:24.103471 #38857]  INFO -- : [Generate OAS schema files] start
I, [2020-05-01T01:31:24.103509 #38857]  INFO -- : <From routes data>
I, [2020-05-01T01:31:24.103546 #38857]  INFO -- : <Update schema files>
I, [2020-05-01T01:31:24.106149 #38857]  INFO -- :  Add schema file into store: 	oas_docs/src/openapi.yml
I, [2020-05-01T01:31:24.108049 #38857]  INFO -- :  Add schema file into store: 	oas_docs/src/info.yml
I, [2020-05-01T01:31:24.110170 #38857]  INFO -- :  Add schema file into store: 	oas_docs/src/tags.yml
I, [2020-05-01T01:31:24.110190 #38857]  INFO -- :  [Generate OAS schema files (paths)] start
I, [2020-05-01T01:31:24.161252 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.161307 #38857]  INFO -- :  <Update schema files (paths)>
I, [2020-05-01T01:31:24.168345 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v1/task.yml
I, [2020-05-01T01:31:24.174644 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v2/post.yml
I, [2020-05-01T01:31:24.177262 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/blob.yml
I, [2020-05-01T01:31:24.179036 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/direct_upload.yml
I, [2020-05-01T01:31:24.182049 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/disk.yml
I, [2020-05-01T01:31:24.184352 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/representation.yml
I, [2020-05-01T01:31:24.191103 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/user.yml
I, [2020-05-01T01:31:24.191138 #38857]  INFO -- :  [Generate OAS schema files (paths)] end
I, [2020-05-01T01:31:24.192176 #38857]  INFO -- :  Add schema file into store: 	oas_docs/src/external_docs.yml
I, [2020-05-01T01:31:24.193420 #38857]  INFO -- :  Add schema file into store: 	oas_docs/src/servers.yml
I, [2020-05-01T01:31:24.193439 #38857]  INFO -- :  [Generate OAS schema files (components)] start
I, [2020-05-01T01:31:24.284912 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.284948 #38857]  INFO -- :  <Update Components schema files (components/schemas)>
I, [2020-05-01T01:31:24.285956 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T01:31:24.287138 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/blob.yml
I, [2020-05-01T01:31:24.288612 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T01:31:24.289710 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T01:31:24.290637 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/representation.yml
I, [2020-05-01T01:31:24.291558 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T01:31:24.292834 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T01:31:24.409634 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.409687 #38857]  INFO -- :  <Update Components schema files (components/requestBodies)>
I, [2020-05-01T01:31:24.412535 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T01:31:24.415665 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T01:31:24.418540 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T01:31:24.420598 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T01:31:24.423222 #38857]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T01:31:24.470555 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.470597 #38857]  INFO -- :  <Update Components schema files (components/securitySchemes)>
I, [2020-05-01T01:31:24.522482 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.522609 #38857]  INFO -- :  <Update Components schema files (components/parameters)>
I, [2020-05-01T01:31:24.569569 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.569644 #38857]  INFO -- :  <Update Components schema files (components/responses)>
I, [2020-05-01T01:31:24.618008 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.618045 #38857]  INFO -- :  <Update Components schema files (components/examples)>
I, [2020-05-01T01:31:24.663136 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.663172 #38857]  INFO -- :  <Update Components schema files (components/headers)>
I, [2020-05-01T01:31:24.712207 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.712244 #38857]  INFO -- :  <Update Components schema files (components/links)>
I, [2020-05-01T01:31:24.760286 #38857]  INFO -- :  <From routes data>
I, [2020-05-01T01:31:24.760322 #38857]  INFO -- :  <Update Components schema files (components/callbacks)>
I, [2020-05-01T01:31:24.760333 #38857]  INFO -- :  [Generate OAS schema files (components)] end
I, [2020-05-01T01:31:24.760948 #38857]  INFO -- : [Generate OAS docs] Create cache at ./oas_docs/.docs
I, [2020-05-01T01:31:24.760966 #38857]  INFO -- : [Generate OAS schema files] end
I, [2020-05-01T01:31:24.761044 #38857]  INFO -- : [R2-OAS] end
```

</details>

If you run the `bundle exec rake routes:oas:docs` command without the `.docs` file, an error will occur.

```
rake aborted!
R2OAS::NoFileExistsError:
                Can't find the file ./oas_docs/.docs
                Please execute the following command to create ./oas_docs/.docs

                CACHE_DOCS=true bundle exec rake routes:oas:docs
```


<details>

```
$ bundle exec rake routes:oas:docs
I, [2020-05-01T02:24:11.823975 #47636]  INFO -- : [R2-OAS] start
I, [2020-05-01T02:24:12.337130 #47636]  INFO -- : [Generate OAS schema files] start
I, [2020-05-01T02:24:12.337177 #47636]  INFO -- : <From routes data>
I, [2020-05-01T02:24:12.337189 #47636]  INFO -- : <Update schema files>
I, [2020-05-01T02:24:12.339013 #47636]  INFO -- :  Add schema file into store: 	oas_docs/src/openapi.yml
I, [2020-05-01T02:24:12.340182 #47636]  INFO -- :  Add schema file into store: 	oas_docs/src/info.yml
I, [2020-05-01T02:24:12.341872 #47636]  INFO -- :  Add schema file into store: 	oas_docs/src/tags.yml
I, [2020-05-01T02:24:12.341890 #47636]  INFO -- :  [Generate OAS schema files (paths)] start
I, [2020-05-01T02:24:12.391772 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.391817 #47636]  INFO -- :  <Update schema files (paths)>
I, [2020-05-01T02:24:12.393787 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v1/task.yml
I, [2020-05-01T02:24:12.400245 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/api/v2/post.yml
I, [2020-05-01T02:24:12.401931 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/blob.yml
I, [2020-05-01T02:24:12.403456 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/direct_upload.yml
I, [2020-05-01T02:24:12.405666 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/disk.yml
I, [2020-05-01T02:24:12.408723 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/active_storage/representation.yml
I, [2020-05-01T02:24:12.417412 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/paths/user.yml
I, [2020-05-01T02:24:12.417509 #47636]  INFO -- :  [Generate OAS schema files (paths)] end
I, [2020-05-01T02:24:12.420108 #47636]  INFO -- :  Add schema file into store: 	oas_docs/src/external_docs.yml
I, [2020-05-01T02:24:12.421518 #47636]  INFO -- :  Add schema file into store: 	oas_docs/src/servers.yml
I, [2020-05-01T02:24:12.421539 #47636]  INFO -- :  [Generate OAS schema files (components)] start
I, [2020-05-01T02:24:12.516931 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.516967 #47636]  INFO -- :  <Update Components schema files (components/schemas)>
I, [2020-05-01T02:24:12.518440 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T02:24:12.519569 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/blob.yml
I, [2020-05-01T02:24:12.520535 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T02:24:12.521450 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T02:24:12.522427 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/representation.yml
I, [2020-05-01T02:24:12.523469 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T02:24:12.524670 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T02:24:12.576654 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.576697 #47636]  INFO -- :  <Update Components schema files (components/requestBodies)>
I, [2020-05-01T02:24:12.580611 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/user.yml
I, [2020-05-01T02:24:12.582940 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/direct_upload.yml
I, [2020-05-01T02:24:12.585316 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/activestorage/disk.yml
I, [2020-05-01T02:24:12.587631 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v1/task.yml
I, [2020-05-01T02:24:12.589786 #47636]  INFO -- :   Add schema file into store: 	oas_docs/src/components/schemas/api/v2/post.yml
I, [2020-05-01T02:24:12.650356 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.650394 #47636]  INFO -- :  <Update Components schema files (components/securitySchemes)>
I, [2020-05-01T02:24:12.710266 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.710302 #47636]  INFO -- :  <Update Components schema files (components/parameters)>
I, [2020-05-01T02:24:12.760227 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.760265 #47636]  INFO -- :  <Update Components schema files (components/responses)>
I, [2020-05-01T02:24:12.818019 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.818056 #47636]  INFO -- :  <Update Components schema files (components/examples)>
I, [2020-05-01T02:24:12.867610 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.867649 #47636]  INFO -- :  <Update Components schema files (components/headers)>
I, [2020-05-01T02:24:12.921801 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.921836 #47636]  INFO -- :  <Update Components schema files (components/links)>
I, [2020-05-01T02:24:12.971004 #47636]  INFO -- :  <From routes data>
I, [2020-05-01T02:24:12.971040 #47636]  INFO -- :  <Update Components schema files (components/callbacks)>
I, [2020-05-01T02:24:12.971052 #47636]  INFO -- :  [Generate OAS schema files (components)] end
rake aborted!
R2OAS::NoFileExistsError:
                Can't find the file ./oas_docs/.docs
                Please execute the following command to create ./oas_docs/.docs

                CACHE_DOCS=true bundle exec rake routes:oas:docs
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/schema/v3/generator/doc_generator.rb:73:in `save_diff_schemas_from'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/schema/v3/generator/doc_generator.rb:28:in `save_schemas_from_store'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/schema/v3/generator/doc_generator.rb:20:in `generate_docs'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/tasks/main.rake:17:in `block (4 levels) in <top (required)>'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/task_logging.rb:25:in `start'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/tasks/main.rake:13:in `block (3 levels) in <top (required)>'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/task_logging.rb:11:in `block in task'
/Users/yukihirop/RubyProjects/r2-oas/example-523/vendor/bundle/ruby/2.3.0/gems/rake-12.3.3/exe/rake:27:in `<top (required)>'
/Users/yukihirop/.rbenv/versions/2.3.3/bin/bundle:22:in `load'
/Users/yukihirop/.rbenv/versions/2.3.3/bin/bundle:22:in `<main>'
Tasks: TOP => routes:oas:docs
(See full trace by running task with --trace)
```

</details>

## If you want to inspect .docs

You can check it by entering the following code with `pry` or something.

```ruby
result = IO.binread("oas_docs/.docs")
inflate = Zlib::Inflate.inflate(result)
puts Marshal.load(inflate)
```
