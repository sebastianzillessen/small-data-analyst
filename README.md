Master: [![Build Status](https://travis-ci.org/sebastianzillessen/small-data-analyst.svg?branch=master)](https://travis-ci.org/sebastianzillessen/small-data-analyst)
Develop: [![Build Status](https://travis-ci.org/sebastianzillessen/small-data-analyst.svg?branch=develop)](https://travis-ci.org/sebastianzillessen/small-data-analyst)

[![Code Climate](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/badges/gpa.svg)](https://codeclimate.com/github/sebastianzillessen/small-data-analyst)
[![Test Coverage](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/badges/coverage.svg)](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/coverage)


# Installation Guide
The following installation guide has been tested on a clean debian OS:

1. Install `postgresql` and `R` with: `sudo apt-get install postgresql r-base`
2. Install `rvm` following [this guide](https://rvm.io/rvm/install).
3. Clone the repository: `git clone https://github.com/sebastianzillessen/small-data-analyst.git`
4. `cd small-data-analyst`
5. Install the required ruby version as prompted by rvm: `rvm install ruby-2.2.4`
6. Install bundler: `gem install bundler foreman`
7. Install all required gems: `bundle install`
8. Set the AWS credentials in the file `.env`: 

        PORT=3000
        AWS_ACCESS_KEY_ID=XXXXXXXXXXXXX
        AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYYYYY
        S3_BUCKET_NAME=ZZZZZZZZZZZZZZ

9. Set the database credentials if required in `config/database.yml`.
10. Initialise the database: `rake db:create && rake db:setup && rake db:migrate`
10. Start the server with `foreman start`
11. Create an Admin user: 

        rails console
        u = User.create(email: "test1@test.de", password: "fooPassword", approved: true, role: :admin)
        u.confirm!

12. Navigate to `http://localhost:3000` and play around with the application.

# Folder structure 

The following should explain to a reader who is not familiar with the naming and folder structure conventions, how the submission is structured.

## app
This folder contains the core source code and functionality of the application. Ruby on Rails is an MVC framework, so this folders substructure explains the basic purpose of each directory easily.

### app/assets
Dynamic stylesheets, Javascript files and images are located in here. These will be packed by the `asset pipeline` to provide a single file for each of them to ensure efficient access in production environments. 
The files `app/assets/javascripts/application.js` and `app/assets/stylesheets/application.css` are key entry points. Sass, Less and Coffeescript are used for more efficient assets generation.

### app/controllers
This folder contains the controllers which are in charge of orchestrating the model and views. These controllers render the views, which can be found in `app/views/<controller>/<action>`. The file `app/controllers/application_controller.rb` is the parent of all other controllers and defines default behaviour (such as sign-in).

### app/helpers
Helpers are used in views to generate recurring HTML elements. This functionality is then available during the view processing and can simplify view generation (such as button generation). 

### app/mailers
Contains controllers for email specific functionality. In this project, emails are only used during the signing-in process and the approval of users. 

### app/models 
The actual models of the application are defined in here and are usually directly reflected as an entity in the database. Ruby on Rails makes it easy to read and write entities, that are defined in here from the database. 

### app/views
The views folder contains all the relevant views to render controller actions. The folder structure follows this pattern: `app/views/<controller>/<action>`, so finding the relevant view to a controller can be easily achieved. 

### app/views/layouts
The general layout of an application is located in here. The different content areas are defined and the import of the assets is done in here. 
 
## config
This folder contains the configuration files for the application, such as database (`config/database.yml`), Amazon S3, environment specific (`config/environments/<production|testing|development>.rb`) and third-party libraries configuration.

## db
The relevant files for the database are all located in here. This includes migrations, data seeds and schema definitions.

## Gemfile
The used third-party libraries are all listed in here. It is used to require the `gem`s from http://rubygems.org.

## spec 
The defined tests (unit, integration and end-to-end) can be found in this directory. The spec runners can be found in here as well. 

## public 
Contains public accessible files such as images.

## lib
This folder contains all application specific libraries. 

### lib/extended_argumentation_framework
This folder contains the implementation of the solver of for EAFs and AFs. As the original plan was to extract them into a separate `gem `, they have been moved to this directory. 


# LICENCE
This project is licenced under the MIT License.


Copyright (c) 2016 Sebastian Zillessen [mailto:sebastian@zillessen.info]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
