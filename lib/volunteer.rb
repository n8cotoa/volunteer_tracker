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

  def ==(another_volunteer)
    self.name.==(another_volunteer.name).&self.project_id.==(another_volunteer.project_id)
  end

end
