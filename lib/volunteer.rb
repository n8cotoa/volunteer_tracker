class Volunteer
  attr_reader(:name, :project_id, :id)

  def initialize(attr)
    @name = attr.fetch(:name)
    @project_id = attr.fetch(:project_id)
    @id = attr.fetch(:id)
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    returned_volunteers.each do |volunteer|
      name = volunteer['name']
      project_id = volunteer.fetch('project_id').to_i
      id = volunteer['id'].to_i
      volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    volunteers
  end

  def save
    results = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', #{@project_id}) RETURNING id;")
    @id = results.first['id']
  end

  def update(attr)
    @project_id = attr.fetch(:project_id, @project_id)
    DB.exec("UPDATE volunteers SET project_id = #{@project_id} WHERE id = #{self.id};")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id};")
  end

  def project
    project = DB.exec("SELECT title FROM projects WHERE id = #{self.project_id};")
    project_title = project.first["title"]
  end

  def self.find(id)
    returned_volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id};")
    id = returned_volunteer.first["id"].to_i
    project_id = returned_volunteer.first["project_id"].to_i
    name = returned_volunteer.first["name"]
    volunteer = Volunteer.new({:name => name, :project_id => project_id, :id => id})
  end

  def ==(another_volunteer)
    self.name.==(another_volunteer.name).&self.project_id.==(another_volunteer.project_id)
  end

end
