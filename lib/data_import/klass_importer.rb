class DataImport::KlassImporter
  def initialize
    @klass_keys = %w[sor wiz cleric druid ranger bard paladin alchemist summoner witch inquisitor oracle antipaladin magus]
    @klass_name_keys = {"sor" => "Sorcerer", "wiz" => "Wizard" }
    @existing_klasses = Klass.all.to_a
    @lookup = nil
  end

  def import
    @klass_keys.each do |k|
      name = (@klass_name_keys[k] || k).humanize

      klass = @existing_klasses.detect { |x| x.name == name }

      unless klass
        Klass.new({:name => name}, :without_protection => true).save!
      end
    end

    @existing_klasses = Klass.all.to_a
    build_lookup
  end

  def get_klass(key)
    @lookup[key.downcase]
  end

  def keys
    @klass_keys
  end

  private

  def build_lookup

    @lookup = {}

    @klass_keys.each do |key|
      name = (@klass_name_keys[key] || key).humanize
      klass = @existing_klasses.detect { |x| x.name == name }

      raise "Missing klass: #{key}" unless klass

      @lookup[key] = klass
    end
  end
end