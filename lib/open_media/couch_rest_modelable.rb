require 'addressable/uri'
require 'rdf'
module OpenMedia
  module CouchRestModelable

    def generate_identifier
      self.label ||= self.term.humanize
      
      class_basename = self.class.to_s.demodulize.downcase
      eterm = escape_string(self.term.downcase)
      this_id = %W[#{class_basename} #{self.authority.term} #{eterm}].select {|v| !v.blank?}.join('_')

      write_attribute(:identifier, this_id)
    end

    def escape_string(str)
      str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_')
    end

    def generate_public_uri
      if self.class.name == "LinkedData::Vocabulary"
        if self.base_uri.include?("http://civicopenmedia.us") && !self.base_uri.include?("vocabularies")
          rdf_uri = RDF::URI.new(self.base_uri)/"vocabularies"/escape_string(self.term)
        else
          rdf_uri = RDF::URI.new(self.base_uri)/self.term
        end
      elsif self.class.name == "LinkedData::Collection"
        rdf_uri = RDF::URI.new(self.base_uri)/"collections"/escape_string(self.term)
      else
        rdf_uri = RDF::URI.new(self.vocabulary.base_uri)/self.vocabulary.property_delimiter + self.term
      end
      self.public_uri = rdf_uri.to_s
    end
  
  end
end