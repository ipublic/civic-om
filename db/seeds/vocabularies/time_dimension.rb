## Note -- prepopulate this database

props = []
props << LinkedData::Property.new(:label => "Full date", :term => "full_date", :expected_type => RDF::XSD.date.to_s, :key => true)
props << LinkedData::Property.new(:label => "Year month", :term => "year_month", :expected_type => RDF::XSD.gYearMonth.to_s, :comment => 'YYYY-MM, for example: 2011-04', :key => true)
props << LinkedData::Property.new(:label => "Calendar year", :term => "calendar_year", :expected_type => RDF::XSD.gYear.to_s, :key => true)
props << LinkedData::Property.new(:label => "Month day", :term => "month_day", :expected_type => RDF::XSD.gMonthDay.to_s, :comment => 'MM-DD, for example: 06-01 for June 1', :key => true)
props << LinkedData::Property.new(:label => "Day number of month", :term => "day_number_of_month", :expected_type => RDF::XSD.gDay.to_s, :comment => 'DD, for example 05 for 5th of the month', :key => true)
props << LinkedData::Property.new(:label => "Calendar month number", :term => "calendar_month_number", :expected_type => RDF::XSD.gMonth.to_s, :comment => 'MM, for example 06 for June', :key => true)

props << LinkedData::Property.new(:label => "Day number of week", :term => "day_number_of_week", :key => true)
props << LinkedData::Property.new(:label => "Calendar quarter", :term => "calendar_quarter", :key => true)

comment = "A vocabulary to partition datasets into non-overlapping time slices "
LinkedData::Vocabulary.create!(:base_uri => "http://civiopenmedia.us/vocabularies/", 
                                        :label => "Time dimension",
                                        :term => "time_dimension",
                                        :property_delimiter => "#",
                                        :curie_prefix => "td",
                                        :authority => @om_site.authority,
                                        :properties => props,
                                        :tags => ["cube", "data warehouse", "dimension", "intrinsic"],
                                        :comment => comment
                                        )
