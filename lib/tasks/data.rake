
task :dedupe => :environment do

  dupe_names = Spell.connection.exec_query('select name from spells group by name having count(*) > 1').map { |r| r['name'] }

  dupe_names.each do |name|

    spells = Spell.where(name: name).order(:created_at).to_a
    newest = spells.last
    others = spells[0...-1]

    new_klass_spells = newest.klass_spells

    others.each do |old_spell|
      old_klass_spells = old_spell.klass_spells

      old_klass_spells.each do |old_ks|
        new_ks = new_klass_spells.detect {|ks| ks.klass_id == old_ks.klass_id }
        old_ks.klass_spell_spell_books.each do |kssb|
          kssb.klass_spell = new_ks
          kssb.save
        end
      end

      old_spell.reload
      old_spell.destroy
    end


  end

end