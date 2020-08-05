# PRASHNA

This is a question-answer site similar to Quora, but with a credit system.
It works on Ruby on Rails framework.

* **Rails version**: 6.0.3.2

* **Ruby version**: ruby 2.7.1-p83

* **Database**: mysql2

## Configuration

After downloading the project, use `bundle install` to install all the dependencies.
After this is done, configure application.yml and database.yml from application.yml.example and database.yml.example respectively, as per your system.

## Rake Task

### Setting up Admin Account

Use this to create an admin account, which used for adminstrative purposes. Use `rails admin:new` to run rake task

### Generating Auth Token

Use this to create auth token for old users. Use `rails gen_auth_token` to run rake task.

### Creating Default Packs

Use this to create some default credit packs, including signup. Use `rails create_credit_packs` to run rake task.

### Port Legacy User's Signup credit transaction's creditable

Use this to port user's signup transactions creditable to Pack. Use `rails port_legacy_signup_transactions` to run rake task.
