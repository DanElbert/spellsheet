# encoding: UTF-8

require 'csv'

class DataImport::Importer

  SpellData = Struct.new(:spell, :levels)
  SpellLevel = Struct.new(:klass, :level)

  SpellColumnMap = {
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

  def self.import(file)

    spells = Spell.includes(:klass_spells => :klass).to_a

    klass_importer = DataImport::KlassImporter.new
    klass_importer.import

    school_importer = DataImport::SchoolImporter.new

    Spell.transaction do
      CSV.foreach(file, {:headers => :first, :encoding => 'UTF-8'}) do |row|
        school = school_importer.get_school(row["school"])

        spell_attrs = {}

        SpellColumnMap.each do |k, v|
          spell_attrs[k] = row[(v || k).to_s]
        end

        spell = spells.detect { |s| s.name.downcase.strip == row['name'].downcase.strip }
        spell ||= Spell.new

        spell_attrs[:school] = school
        spell.update_attributes!(spell_attrs, :without_protection => true)

        klass_importer.keys.each do |key|
          if row[key] =~ /^[0-9]+$/
            klass = klass_importer.get_klass(key)
            ks = spell.klass_spells.detect { |x| x.klass_id == klass.id }
            ks ||= KlassSpell.new({spell: spell, klass: klass}, {:without_protection => true})
            ks.level = row[key].to_i
            ks.save!
          end
        end
      end
    end
  end
end