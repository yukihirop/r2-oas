# Initialize

!> Since `v0.4.1`, rake tasks are not automatically loaded. Please write `R2OAS.load_tasks` in `Rakefile` and load it.

API document management using r2-oas begins with the execution of this command.

After requiring a gem and Configure `Rakefile` in your rails project

```rb
R2OAS.load_tasks
```

```bash
$ bundle exec rake routes:oas:init
```

By default, the directory is created as follows.

```bash
$ tree -a oas_docs
oas_docs
├── .paths
├── plugins
│   ├── .gitkeep
│   └── helpers
│       └── .gitkeep
└── tasks
    └── .gitkeep
    └── helpers
        └── .gitkeep

3 directories, 4 files
```

|name|description|remark|
|----|-----------|------|
|`.paths`|By writing the path of the yaml file of path item in this file, you can limit the endpoint used in `Swagger UI` and `build` and `deploy`.|[configure#paths](/setting/configure?id=paths)|
|`plugins`|Storage location for locally defined plugins.|[usage/use_plugins](/usage/use_plugins)|
|`plugins/helpers`|This directory is used to define classes used by plugins.||
|`tasks`|Storage location for locally defined rake tasks.|[usage/define_tasks](/usage/define_tasks)|
|`tasks/helpers`|This directory is for defining classes used in rake tasks.||
