# Change Log

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
