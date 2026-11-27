# Validation Points

A Kanban-style workflow management platform built with Ruby on Rails 8, focused on tracking tasks, epics, code reviews, and real-time delivery validations.

## Tech Stack

- **Language & Framework:** Ruby `3.3.14` / Ruby on Rails `8.1.4`
- **Database:** PostgreSQL 16
- **Frontend:** Hotwire (Turbo Frames, Turbo Streams & Stimulus), Tailwind CSS v4, Importmap
- **Queues & Background Jobs:** Sidekiq + Redis 7
- **Authentication & Authorization:** Devise + Pundit
- **Uploads & Images:** Active Storage (`image_processing` / libvips)
- **Mailers:** ActionMailer + `letter_opener_web` (in development)
- **Architecture:** MVC + Operations Pattern (`app/operations/`)
- **Testing & Code Quality:** RSpec, RuboCop (`rubocop-rails-omakase`), Brakeman, and Bundler Audit

## Key Features

- **Real-Time Kanban Board:** Move tasks across stages with drag-and-drop and live synchronization via Turbo Streams (`broadcast_refresh_to`).
- **Review Management:** Quick reviewer assignment and unassignment (`toggle_reviewer`) with automatic cleanup when changing task stages.
- **Asynchronous Notifications via Sidekiq:**
  - Welcome email upon user registration (`UserMailer.user_created`).
  - Team notification when a code review starts (`TaskMailer.reviewer_assigned`).
  - Delivery notification when a task reaches production (`TaskMailer.task_completed`).
  - Priority alert on the `critical` queue for urgent tasks (`Tasks::UrgentAlertJob`).
- **Admin Dashboard (`/admin`):** Workflow metrics, user/role management, and access to the **Sidekiq Web UI (`/sidekiq`)** restricted to administrators.
- **Profile & Security:** Avatar upload with format (PNG/JPG) and size (up to 5MB) validation, password recovery with 10-minute token expiration, and `pt-BR` internationalization.

## Prerequisites

- Ruby `3.3.14` (via RVM, rbenv, or asdf)
- Bundler
- Docker and Docker Compose
- `libvips` and `libpq-dev` system libraries (for Active Storage and PostgreSQL)

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd validation_points
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   ```

3. **Start PostgreSQL and Redis via Docker:**
   ```bash
   docker compose up -d
   ```

4. **Install Ruby dependencies:**
   ```bash
   bundle install
   ```

5. **Prepare the database:**
   ```bash
   bin/rails db:prepare
   ```

6. **Start the server, Tailwind CSS, and Sidekiq worker:**
   ```bash
   bin/dev
   ```

## Useful Development URLs

- **Application:** `http://localhost:3000`
- **Email Inbox (Letter Opener Web):** `http://localhost:3000/letter_opener`
- **Queue Dashboard (Sidekiq — Admins only):** `http://localhost:3000/sidekiq`

## Testing & Code Quality

- **Run the test suite (RSpec):**
  ```bash
  bundle exec rspec
  ```

- **Check code style (RuboCop):**
  ```bash
  bin/rubocop
  ```

- **Run security checks (Brakeman & Bundler Audit):**
  ```bash
  bin/brakeman --no-pager -w2
  bin/bundler-audit
  ```

## Additional Architecture Structure

Beyond the standard Rails structure (`models`, `views`, `controllers`, `mailers`, `jobs`), the project uses:

- `app/operations/`: **Operations Pattern** layer (`ApplicationOperation` with a `Result` object) to encapsulate business logic and side effects outside controllers.
- `app/policies/`: Authorization policies managed by **Pundit**.
- `config/sidekiq.yml`: Concurrency and queue priority configuration (`critical`, `default`, `mailers`).
