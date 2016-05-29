task :default do
  Rake::Task["db:setup"].invoke
  Rake::Task["teaspoon"].invoke
end