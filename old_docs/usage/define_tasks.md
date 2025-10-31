# 🆕 Define tasks

?> Starting from `v0.4.0`, you can define tasks.  

You can define rake tasks.

## Usage

### Create rake file

Create a file called `oas_docs/tasks/sample.rake`

```rb
# frozen_string_literal: true

namespace :custom do
  namespace :your do
    desc 'custom your task'
    task :task do
      # e.g.)
      # I, [2020-07-14T22:53:47.328715 #55113]  INFO -- : [CUSTOM YOUR TASK] start
      # something
      # I, [2020-07-14T22:53:47.328811 #55113]  INFO -- : [CUSTOM YOUR TASK] end
      start '[CUSTOM YOUR TASK]' do
        # something
        puts 'something'
      end
    end
  end
end
```

### Load rake tasks

Read with `Rakefile`. If `Rails.application.load_tasks` is written, write it below it.

```diff
Rails.application.load_tasks
+ R2OAS.load_tasks
```

### Confirm rake tasks

Check if the defined rake task is loaded.

```bash
$ bundle exec rake -T
```

```
rake custom:your:task                   # custom your task
```
