class Volunteer
  attr_reader(:name, :project_id, :id)

  def initialize(attr)
    @name = attr.fetch(:name)
    @project_id = attr.fetch(:project_id)
    @id = attr.fetch(:id)
  end

end
