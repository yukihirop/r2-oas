# Selenium::WebDriver::Error::SessionNotCreatedError

If you get the following error when running `oas:docs:editor`, the chromedriver may be old

```bash
rake aborted!
Selenium::WebDriver::Error::SessionNotCreatedError: session not created: This version of ChromeDriver only supports Chrome version 81
  (Driver info: chromedriver=81.0.4044.69 (6813546031a4bc83f717a2ef7cd4ac6ec1199132-refs/branch-heads/4044@{#776}),platform=Mac OS X 10.14.3 x86_64)
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/response.rb:72:in `assert_ok'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/response.rb:34:in `initialize'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/http/common.rb:88:in `new'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/http/common.rb:88:in `create_response'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/http/default.rb:114:in `request'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/http/common.rb:64:in `call'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/bridge.rb:167:in `execute'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/bridge.rb:102:in `create_session'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/remote/bridge.rb:56:in `handshake'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/chrome/driver.rb:43:in `initialize'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/common/driver.rb:46:in `new'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver/common/driver.rb:46:in `for'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/selenium-webdriver-3.142.4/lib/selenium/webdriver.rb:88:in `for'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/watir-6.16.5/lib/watir/browser.rb:46:in `initialize'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/schema/editor.rb:110:in `new'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/schema/editor.rb:110:in `open_browser_and_set_schema'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/schema/editor.rb:37:in `block in start'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/eventmachine-1.2.7/lib/eventmachine.rb:195:in `run_machine'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/eventmachine-1.2.7/lib/eventmachine.rb:195:in `run'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/schema/editor.rb:35:in `start'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/tasks/main.rake:53:in `block (4 levels) in <top (required)>'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/task_logging.rb:25:in `start'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/tasks/main.rake:45:in `block (3 levels) in <top (required)>'
/Users/yukihirop/RubyProjects/r2-oas/lib/r2-oas/task_logging.rb:11:in `block in task'
/Users/yukihirop/RubyProjects/r2-oas/example-600/vendor/bundle/ruby/2.5.0/gems/rake-12.3.3/exe/rake:27:in `<top (required)>'
/Users/yukihirop/.rbenv/versions/2.5.3/bin/bundle:23:in `load'
/Users/yukihirop/.rbenv/versions/2.5.3/bin/bundle:23:in `<main>'
Tasks: TOP => routes:oas:editor
(See full trace by running task with --trace)
```

The solution is as follows

```bash
brew cask upgrade chromedriver
```
