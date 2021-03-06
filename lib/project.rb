class Project
  attr_reader(:title, :id)

def initialize(attr)
  @title = attr.fetch(:title)
  @id = attr.fetch(:id)
end

def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      title = project['title']
      id = project['id']
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
end

def self.find(id)
  returned_project = DB.exec("SELECT * FROM projects WHERE id = #{id};")
  id = returned_project.first["id"].to_i
  title = returned_project.first["title"]
  project = Project.new({:title => title, :id => id})
end

def save
  result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
  @id = result.first.fetch('id').to_i
end

def update(attr)
  @title = attr.fetch(:title, @title)
   DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{self.id};")
end

def delete
  DB.exec("DELETE FROM projects WHERE id = #{self.id};")
end

def volunteers
  project_volunteers = []
  volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
  volunteers.each do |volunteer|
    name = volunteer['name']
    project_id = volunteer['project_id'].to_i
    id = volunteer['id'].to_i
    project_volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
  end
  project_volunteers
end

def ==(another_project)
  self.title.==(another_project.title)
end

end
