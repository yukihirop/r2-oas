# Change Log

## v0.4.0

2020-07-22

- [`BigFeature`] 🎯 Implement plugin ([#154](https://github.com/yukihirop/r2-oas/pull/154))
    - Please see [use plugins docs](https://yukihirop.github.io/r2-oas/#/usage/use_plugins)
- [`Feature`] Implement `routes:oas:init`([#154](https://github.com/yukihirop/r2-oas/pull/154))
    - Please see [initialize docs](https://yukihirop.github.io/r2-oas/#/usage/initialize)
- [`Breaking`] Rename from `routes:oas:dist` to `routes:oas:build` ([#154](https://github.com/yukihirop/r2-oas/pull/154))
- [`Feature`] Allowed definition of custom rake tasks ([#152](https://github.com/yukihirop/r2-oas/pull/152))
    - Please see [define tasks docs](https://yukihirop.github.io/r2-oas/#/usage/define_tasks)
- [`Deprecated`] Deprecated use of `R2OAS.use_object_classes=` ([#155](https://github.com/yukihirop/r2-oas/pull/155))

Please see milestone [v0.4.0](https://github.com/yukihirop/r2-oas/milestone/4?closed=1)

## v0.3.4

2020-07-11

- [`Other`] Modify gemspec `files` fields ([#147](https://github.com/yukihirop/r2-oas/pull/147))
    - Add `r2-oas.gemspec` into gemspec `files`

## v0.3.3

2020-07-11

- [`FixBugs`] A cute pet store syndrome 🐈 ([f3f4c30](https://github.com/yukihirop/r2-oas/pull/144))
- [`FixBugs`]  R2OAS.logger.level does not work ([f3f4c30](https://github.com/yukihirop/r2-oas/pull/144))
- [`Breaking`] Change default namespace type from `:underbar` to `:dot` ([f3f4c30](https://github.com/yukihirop/r2-oas/pull/144))
- [`Other`] Modify gemspec `files` fields ([f3f4c30](https://github.com/yukihirop/r2-oas/pull/144))

Please see milestone [v0.3.3](https://github.com/yukihirop/r2-oas/milestone/3?closed=1)

## v0.3.2

2020-07-05

- [`Feature`] The file size at the time of gem install was reduced by about 10MB. ([dbdbce9 ](https://github.com/yukihirop/r2-oas/pull/138))

## v0.3.1

2020-06-07

- [`Breaking`] Remove unnecessary runtime dependencies ([384ea1a](https://github.com/yukihirop/r2-oas/pull/132))

## v0.3.0

2020-05-30

- [`Feature/Breaking`] Support Ruby 2.7 🎉 ([931ec4b](https://github.com/yukihirop/r2-oas/pull/122))

  - Remove `Gemfile.lock`

- [`Developer`] Create script to test all support ruby in development ([8d0df98](https://github.com/yukihirop/r2-oas/pull/124))
- [`Docs`] Add docs about Trableshouting ([f4a782f](https://github.com/yukihirop/r2-oas/pull/125))

## v0.2.0

2020-05-02

- [`Feature/Breaking`] Upgrade `routes:oas:docs` cmd ([37ccddf](https://github.com/yukihirop/r2-oas/pull/117))
  
  - `.docs` is needed to continue using r2-oas. `If you are using previous version`,you need to run the following command to generate `.docs`.

    ```bash
    CACHE_DOCS=true bundle exec rake routes:oas:docs
    ```

- [`Breaking`] Divide into `Generator` and `Builder` ([00fea7d](https://github.com/yukihirop/r2-oas/pull/116))
  - `routes:oas:docs` cmd do not generate `oas_docs/oas_doc.yml`

## v0.1.3

2020-04-27

- [`FixBugs`] Fix clash when edit ([906d068](https://github.com/yukihirop/r2-oas/pull/109))
- [`Feature`] Change log display to relative path ([c735d22](https://github.com/yukihirop/r2-oas/pull/111))

## v0.1.2

2020-04-22

- No Change

## v0.1.1

2020-04-22

- [`Feature`] Create document by docsify([def4463](https://github.com/yukihirop/r2-oas/pull/99))
- [`Breaking`] Do not generate component schema when http_status equal 204 and 404 by default ([f7fcafd](https://github.com/yukihirop/r2-oas/pull/103))


## v0.1.0

2019-10-22 / The day of the throne (called 即位礼正殿の儀の行われる日 in Japanease)

- first release
