Master: [![Build Status](https://travis-ci.org/sebastianzillessen/small-data-analyst.svg?branch=master)](https://travis-ci.org/sebastianzillessen/small-data-analyst)
Develop: [![Build Status](https://travis-ci.org/sebastianzillessen/small-data-analyst.svg?branch=develop)](https://travis-ci.org/sebastianzillessen/small-data-analyst)

[![Code Climate](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/badges/gpa.svg)](https://codeclimate.com/github/sebastianzillessen/small-data-analyst)
[![Test Coverage](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/badges/coverage.svg)](https://codeclimate.com/github/sebastianzillessen/small-data-analyst/coverage)

### Installation Guide
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

### LICENCE
This project is licenced under the MIT License.


Copyright (c) 2016 Sebastian Zillessen [mailto:sebastian@zillessen.info]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
