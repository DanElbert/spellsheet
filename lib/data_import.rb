module DataImport
end

files = %w(klass_importer school_importer importer)

files.each do |f|
  require Rails.root.join('lib', 'data_import', f).to_s
end