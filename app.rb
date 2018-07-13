
require('sinatra')
require("sinatra/reloader")
also_reload('lib/**/*.rb')
require('./lib/project')
require('./lib/volunteer')
require('pg')
require('pry')

DB = PG.connect({:dbname => "volunteer_tracker_test"})

get('/') do
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:index)
end

post('/new_project') do
  title = params.fetch("title")
  project = Project.new({:title => title, :id => nil})
  project.save
  redirect back
end

post('/new_volunteer') do
  name = params.fetch("name")
  project_id = params.fetch("project_id")
  volunteer = Volunteer.new({:name => name, :project_id => project_id, :id => nil})
  volunteer.save
  redirect back
end

get('/project/:id') do
  id = params[:id].to_i
  @project = Project.find(id)
  @volunteers = @project.volunteers
  erb(:project)
end
