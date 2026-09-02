# Bicycle Maintenance Tracker

A Ruby on Rails application for tracking bikes, components and maintenance history. Users can create an account, manage their bikes, maintain a personal catalog of components, install components on bikes, and record maintenance logs tied to bikes and components. The app features a responsive UI and is linted with a course-provided RuboCop configuration.

## Table of Contents
- [Features](#features)
- [Tech](#tech)
- [Setup](#setup)
- [Running the App](#running-the-app)
- [Running Tests](#running-tests)
- [Linting](#linting)
- [Formatting ERB Views](#formatting-erb-views)
- [Database](#database)
- [Routes](#routes)
- [License](#license)

## Features 
1. **User Authentication**
   - Sign up, log in, and log out
   - Passwords hashed with `bcrypt`
   - Session-based authentication with required-login helpers

2. **Bike Management**
   - Add, edit, and delete bikes
   - Each bike belongs to a user and has a name and brand

3. **Component Management**
   - Create a personal catalog of components (e.g., chains, tires, cassettes)
   - Components belong to the logged-in user and are only visible to that user
   - Components have a name, type, and optional expected lifespan in kilometers

4. **Bike-Component Installation**
   - Install components from the user's personal catalog on their bikes with an installation date and current kilometer reading
   - Remove components from a bike without deleting the component catalog entry
   - Validation prevents duplicate installations, future installation dates, and installing components that belong to another user

5. **Maintenance Logs**
   - Record maintenance performed on a bike (service date, description, km at service)
   - Optionally associate a maintenance log with a component installed on that bike
   - Full CRUD nested under bikes

6. **View Maintenance by Association**
   - The component detail page lists all maintenance logs recorded for that component across bikes

7. **Validation and Error Handling**
   - Maintenance logs can only reference components that are installed on the same bike
   - Missing or unauthorized records gracefully redirect to the home page with a flash alert
   - Shared error-partial used across model forms


## Tech

- Ruby on Rails 8.1
- SQLite3
- Propshaft asset pipeline
- Puma web server
- RSpec for testing
- RuboCop for linting (with the `rubocop-performance` plugin)
- Factory Bot for test data
- Herb for ERB formatting (development/test)

## Setup

1. Clone the repository and navigate to the project directory:

   ```bash
   git clone <repository-url>
   cd bicycle-maintenance-tracker
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Create and migrate the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

4. (Optional) Run the test suite to confirm everything is working:

   ```bash
   bundle exec rspec
   ```

## Running the App

Start the Rails server:

```bash
bin/rails server
```

Then visit [http://localhost:3000](http://localhost:3000).

The root path shows the logged-in user's bikes. If no user is logged in, the app redirects to the log-in page.

## Running Tests

```bash
bundle exec rspec
```

## Linting

The project uses the provided `.rubocop.yml` configuration, which includes the `rubocop-performance` plugin and enforces the Nitro Umbrella style rules.

Check for offenses:

```bash
bundle exec rubocop
```

Auto-correct safe offenses:

```bash
bundle exec rubocop -a
```

## Formatting ERB Views

The project uses the [`herb`](https://github.com/nickrivadeneira/herb) gem to format ERB templates. Run it from the project root:

```bash
bundle exec herb app/views
```

## Database

The application uses SQLite3 with database files stored in the `db/` directory:

- `db/development.sqlite3`
- `db/test.sqlite3`
- `db/production.sqlite3`


## Routes

| Path | Description |
|------|-------------|
| `/` | Home / bike list (requires login) |
| `/signup` | Create a new account |
| `/login` | Log in |
| `/logout` | Log out |
| `/bikes` | Manage bikes |
| `/bikes/:bike_id/maintenance_logs` | Manage maintenance logs for a bike |
| `/bikes/:bike_id/bike_components/new` | Install a component on a bike |
| `/components` | Manage personal component catalog |

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
