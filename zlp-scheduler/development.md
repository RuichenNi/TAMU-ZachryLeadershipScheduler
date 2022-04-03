# Setup zlp-scheduler development environment on Cloud9

This document shows how to development zlp-scheduler on AWS cloud 9. If you are using other envirounment, the command can be different.

Before building the environment, you need to create a new Cloud9 Ubuntu Instance.

## Setup your GitHub name and email

Use your username from github.com, **not** github.tamu.edu.

```sh
git config --global user.name "YourUserName"
git config --global user.email "YourEmail@gmail.com"
git config --global credential.helper store
```

You may follow this [guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to setup ssh key.


## Prepare PostgreSQL

The zlp-scheduler use PostgreSQL database.

### Install

```sh
sudo apt-get install libpq-dev
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt install wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install postgresql-14
```
PostgreSQL server will start automatically after install.

### Create PostgreSQL user
By default, the username in Cloud9 is called `ubuntu`, so we need to create a user `ubuntu` for PostgreSQL.

```sh
sudo -u postgres createuser --interactive
# Create a user named ubuntu, and select yes
```

## Install firefox and geckodriver for Selenium

```sh
wget https://github.com/mozilla/geckodriver/releases/download/v0.27.0/geckodriver-v0.27.0-linux64.tar.gz
tar -zxvf geckodriver-v0.27.0-linux64.tar.gz
sudo mv geckodriver /usr/local/bin/
rm geckodriver-v0.27.0-linux64.tar.gz
sudo apt-get install firefox
```

## Clone source code and install bundler

```sh
git clone git@github.com:tamu-zlp/zlp-scheduler.git
cd zlp-scheduler/zlp-scheduler
gem install bundler:2.2.22
```

### Install required gems

```sh
cd zlp-schedule
bundle install
```

All the below steps assume the current directory is `zlp-schedule`.

### Reset database

```sh
rake db:drop db:create db:migrate db:seed
```

### Run sever

```sh
rails s
```

The test user name and password is specified in `seeds.rb`, you can also create your own test data.

### Run Cucumber tests

```sh
cucumber features
```

### Run Unit tests

We test the algorithm using unit test.

```sh
rspec spec/controllers
```

### Contribute the source code

Suppose you have made some changes

1. Run `cucumber features` to check if your code broke any existing tests.
2. Create a new branch using `git checkout -b your-branch-name` 
3. Add each file using `git add xxx`
4. `git commit -m "your commit message"`
5. Create a pull request on GitHub, and ask others to review your code
6. Merge and squash (optional) your PR, then delete the branch.
