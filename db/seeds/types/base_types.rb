## Initialize intrinsic types

authority = Authority.create!(:uri => RDF::XSD.string.authority, 
                              :term => RDF::XSD.string.authority.parameterize('_'), 
                              :label => "World Wide Web Consortium XML Schema")
                              
                              

authority = Authority.get 'civicopenmedia.com'

ns = "http://www.w3.org/2001/XMLSchema#"
label = "World Wide Web Consortium XML Schema"

vocab = Type.new(:term => "string", 
                  :authority => authority, 
                  :namespace => ns, 
                  :label => label,
                  :tags => ["intrinsic"])

["anyURI", "base64Binary", "boolean", "byte", "date", "dateTime", "double", "duration", 
  "float", "integer", "long", "short", "string", "time"].each do |term|
    
  prop = Property.new(:term => term, 
                      :label => term.titleize
                      )

  vocab.properties << prop
end


# XMLSchema base types
# core_collection = LinkedData::Collection.get("http://openmedia.dev/om/collections#core")

comment = "Element and attribute datatypes used in XML Schemas and other XML specifications"
vocab = LinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2001", 
                                    :label => "XMLSchema",
                                    :term => "XMLSchema",
                                    :property_delimiter => "#",
                                    :curie_prefix => "xsd",
                                    :authority => @om_site.authority,
                                    :comment => comment
                                    ).save
                                         

vocab.save!                         
