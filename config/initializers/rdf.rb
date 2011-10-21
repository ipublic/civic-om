require 'rdf'
begin
  # Define vocabularies not built-in
  RDF::OM_DATA = RDF::Vocabulary.new('http://data.civicopenmedia.org/')
  RDF::OM_CORE = RDF::Vocabulary.new(RDF::OM_DATA['core/'])
  RDF::DCTYPE = RDF::Vocabulary.new('http://purl.org/dc/dcmitype/')
  RDF::VCARD = RDF::Vocabulary.new(RDF::OM_CORE['vcard/'])
  RDF::METADATA = RDF::Vocabulary.new(RDF::OM_CORE['metadata/'])
  
end