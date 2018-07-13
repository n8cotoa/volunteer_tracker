
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

get('/project/:id') do
  id = params[:id].to_i
  @project = Project.find(id)
  @volunteers = @project.volunteers
  erb(:project)
end

patch('/project/:id') do
 id = params["id"].to_i
 new_title = params['new_title']
 @project = Project.find(id)
 @project.update({:title => new_title})
 @volunteers = Volunteer.all
 erb(:project)
end

delete('/project/:id') do
  id = params['id'].to_i
  @project = Project.find(id)
  @project.delete
  @projects = Project.all
  @volunteers = Volunteer.all
  redirect '/'
  erb(:index)
end

post('/new_volunteer') do
  name = params.fetch("name")
  project_id = params.fetch("project_id")
  volunteer = Volunteer.new({:name => name, :project_id => project_id, :id => nil})
  volunteer.save
  redirect back
end

get('/volunteer/:id') do
  id = params[:id].to_i
  @volunteer = Volunteer.find(id)
  @project = @volunteer.project
  @projects = Project.all
  erb(:volunteer)
end

patch('/volunteer/:id') do
 id = params["id"].to_i
 project_id = params['project_id']
 @volunteer = Volunteer.find(id)
 @volunteer.update({:project_id => project_id})
 @projects = Project.all
 @project = @volunteer.project
 erb(:volunteer)
end

delete('/volunteer/:id') do
  id = params['id'].to_i
  @volunteer = Volunteer.find(id)
  @volunteer.delete
  @projects = Project.all
  @volunteers = Volunteer.all
  redirect '/'
  erb(:index)
end
