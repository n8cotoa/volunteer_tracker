class Project
  attr_reader(:title, :id)

def initialize(attr)
  @title = attr.fetch(:title)
  @id = attr.fetch(:id)
end

end
