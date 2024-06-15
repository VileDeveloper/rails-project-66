#!/usr/bin/env bash
# exit on error
set -o errexit

bundle config set --local without development
make install
make yarn_install
make make_env_file
make drop_db
make db_migrate
make db_seed
make compile_assets
make clear_assets
