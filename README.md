# Hexlet project

[![hexlet-check](https://github.com/VileDeveloper/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/VileDeveloper/rails-project-66/actions/workflows/hexlet-check.yml)
[![Rails](https://github.com/VileDeveloper/rails-project-66/actions/workflows/custom-build.yml/badge.svg)](https://github.com/VileDeveloper/rails-project-66/actions/workflows/custom-build.yml)

Deployed [link](https://viledeveloper-rails-project-66.onrender.com)

## Github Quality

This project displays the results of linter checks for public user repositories. Repositories are analyzed where GitHub has identified the primary language as either Ruby or JavaScript. To view the results, users must authenticate via GitHub and select the desired repository from the list. When a repository is added, a webhook is set up that automatically triggers a code check on each new commit to the "push" event.

### Development Commands

- **Setup:**

  ```bash
  make setup
  ```

  Installs dependencies, sets up the database, and precompiles assets.

- **Test:**

  ```bash
  make test
  ```

  Runs tests using Minitest.

- **Lint:**
  ```bash
  make lint
  ```
  Runs RuboCop for linting.
