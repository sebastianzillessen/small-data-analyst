Master: [![Build Status](https://travis-ci.org/sebastianzillessen/small-data-analyst.svg?branch=master)](https://travis-ci.org/sebastianzillessen/small-data-analyst)
Develop: [![Build Status](https://travis-ci.org/sebastianzillessen/small-data-analyst.svg?branch=develop)](https://travis-ci.org/sebastianzillessen/small-data-analyst)

[![Code Climate](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/badges/gpa.svg)](https://codeclimate.com/github/sebastianzillessen/small-data-analyst)
[![Test Coverage](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/badges/coverage.svg)](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/coverage)

# Abstract
Data collection has seen a dramatic increase over the last years and researchers agree exploiting the collected data to create data driven decision processes is crucial to generate valuable insights for clinical studies. This generates the requirement to assist clinicians during the design process of their studies with an intelligent support agent performing these analyses for them. 

This project implements an existing approach to apply argumentation on this problem, by representing the statistical models and their assumptions as a statistical knowledge base and implementing the process into a user-friendly web application. The model selection is influenced by expressing preferences applying on different context domains and the close integration of the clinician and insights she/he can give related to the process. This will enable clinicians -- even without a background in statistics or informatics -- to answer their research questions in an appropriate way and to make evidence based decisions. 

# Software related project aims
Development of an RoR web application that implements the requirements including but not limited to:

- An approach to instantiate and solve AFs and EAFs. 
- The ability to store, manage and reuse research questions, analysis and pref-
erences for statistical models on different data sets.
- An easy to use user interface to upload data collected during clinical studies
and run analyses in an interactive way.
- The ability to deal with preferences between models using EAFs while tak-
ing into account global and personal (end user) preferences. The approach involving context domains will be used. 
- A user rights management to allow the system to be used by clinicians, statis-
ticians and super-users (admins). 
- A small set of statistical models and their assumptions integrated in the
system.
- A comprehensive set of unit and integration tests.
- Hosting at a public accessible provider.

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
