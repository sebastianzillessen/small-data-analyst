# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


u=User.create(email: "sebastian@zillessen.info", password: "123456")
u.confirm!
u.approved = true
u.role= :admin
u.save

if (defined? FactoryGirl)
  FactoryGirl.create(:analysis_survival)
  FactoryGirl.create(:preference_cd1)
  FactoryGirl.create(:preference_cd2)
end