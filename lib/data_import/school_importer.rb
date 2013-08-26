class DataImport::SchoolImporter
  def initialize
    @existing_schools = School.all.to_a
  end

  def get_school(name)
    name = name.downcase.strip
    school = @existing_schools.detect { |s| s.name.downcase == name }

    if school.nil? && name.present?
      school = School.new()
      school.name = name
      school.save!
      @existing_schools << school
    end

    school
  end
end