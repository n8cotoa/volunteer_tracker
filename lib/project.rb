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

def save
  result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
  @id = result.first.fetch('id')
end

def ==(another_project)
  self.title.==(another_project.title)
end

end
