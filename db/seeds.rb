require 'csv'

data_file = File.join(File.dirname(__FILE__), "/data/spell_full.csv")

klasses = {}
schools = {}

csv_column_map = {
    :name => nil,
    :subschool => nil,
    :descriptor => nil,
    :casting_time => nil,
    :components => nil,
    :verbal => nil,
    :somatic => nil,
    :material => nil,
    :focus => nil,
    :divine_focus => nil,
    :short_description => nil,
    :costly_components => nil,
    :range => nil,
    :area => nil,
    :effect => nil,
    :targets => nil,
    :duration => nil,
    :dismissible => nil,
    :shapeable => nil,
    :saving_throw => nil,
    :spell_resistence => nil,
    :description => nil,
    :source => nil    
  }
  
ids = {"klass" => 1, "spell" => 1}

klass_keys = %w[sor wiz cleric druid ranger bard paladin alchemist summoner witch inquisitor oracle antipaladin magus]
klass_name_keys = {"sor" => "Sorcerer", "wiz" => "Wizard" }

klass_keys.each { |k| klasses[k] = Klass.new({:name => (klass_name_keys[k] || k).humanize}, :without_protection => true) }
klasses.values.each { |k| k.id = (ids["klass"] += 1) }
Klass.import klasses.values
spells = []
klass_spells = []


CSV.foreach(data_file, {:headers => :first}) do |row|
  school_name = row["school"]
  school = nil
  if schools[school_name]
    school = schools[school_name]
  elsif !school_name.nil?
    school = School.new()
    school.name = school_name
    school.save
    schools[school_name] = school
  end
  
  spell_attrs = {}
  
  csv_column_map.each do |k, v|
    spell_attrs[k] = row[(v || k).to_s]
  end
  
  spell = Spell.new(spell_attrs, :without_protection => true)
  spell.id = (ids["spell"] += 1)
  spell.school = school
  spells << spell
  
  klasses.each do |key, klass|
    if row[key] =~ /^[0-9]+$/
      kl = KlassSpell.new
      kl.klass = klass
      kl.spell = spell
      kl.level = row[key]
      klass_spells << kl
    end
  end
  
end

Spell.import spells
KlassSpell.import klass_spells
