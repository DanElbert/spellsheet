# encoding: UTF-8

require Rails.root.join('lib', 'data_import')

data_file = File.join(File.dirname(__FILE__), "/data/spell_full.csv")

DataImport::Importer.import(data_file)