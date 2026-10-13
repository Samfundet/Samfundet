# RSpec and coverage

Use the project's Ruby 3.1 runtime and install dependencies with `bundle install`.
PostgreSQL must be available with the credentials in `config/database.yml`.

Prepare the isolated test database:

```sh
RAILS_ENV=test bundle exec rails db:prepare
```

Run the complete suite with a 95% line coverage requirement:

```sh
make test
```

The equivalent command is `COVERAGE_MINIMUM=95 bundle exec rspec`.
SimpleCov starts before Rails and tracks every Ruby file in `app/` and `lib/`,
including files that are not loaded by a test. The HTML report is
`coverage/index.html`. Configuration, assets, third-party libraries and the
specs themselves use the standard SimpleCov Rails profile exclusions.

Run a focused test without the full-suite coverage requirement:

```sh
bundle exec rspec spec/models/applicant_workflow_spec.rb
```

Each run replaces the coverage report. Use a full run when assessing the
codebase's coverage. Line coverage measures executed lines; it does not prove
that every branch or interaction is tested. Controller specs generally stub
view rendering. The mailer and helper examples exercise their output separately.

Tests use transaction cleanup, the test mail delivery adapter, local payment
data, and controlled responses for external registration queries. They do not
require production service credentials.
