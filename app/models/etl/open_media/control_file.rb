require 'etl'

module ETL
  module OpenMedia
    class ControlFile < CouchRest::Model::Base
      include ::OpenMedia::CouchRestModelable
      
      use_database STAGING_DATABASE
      unique_id :identifier
      
      property :identifier, String
      property :term, String
      property :label, String
      property :authority, String
      property :source_types, [String], :read_only => true, :default => %W[file database url]
      property :source_file, String
      property :parser, String
      property :parser_options, :default => {}
      property :source_parameters, :default => {}
      property :definition
      
      validates_presence_of :term
      validates_presence_of :authority
      
      before_create :generate_identifier
      
      design do
        view :by_term
        view :by_label
        view :by_authority
      end
      
      # Provide list of available parsers
      def parser_list
        parent_class = ETL::Parser::Parser
        klass_names = parent_class.descendants.map {|k| k.to_s.demodulize.split("Parser").first}.sort
        list = {}
        klass_names.each {|kn| list[kn.underscore.to_sym] = kn.demodulize.titleize}
        list
      end

      def parser_list_old
        parent_class = ETL::Parser::Parser
        klass_names = parent_class.descendants.map {|k| k.to_s.demodulize}.sort
        list = {}
        klass_names.each do |kn|
          k = kn.split("Parser").first.downcase
          list[k] = kn.titleize
        end
        list
      end

      def to_s
        ctl = "source :in, "
        ctl << self.source_section.to_s
        ctl << ",\n #{self.definition_section.to_s}"
      end

      def write(file)
        dir = file.split(file.split(File::SEPARATOR).last).first
        FileUtils.mkdir_p dir unless Dir.exists? dir
        File.delete(file) if File.exists?(file)
        
        File.open(file, "w") {|f| f << self}
      end
      
      def extract(file)
        control = ETL::Control::Control.resolve(file)
        p_class = ETL::Parser.const_get("#{parser.to_s.camelize}Parser")
        parser = p_class.new(control.sources.first)
        rows = parser.collect { |row| row }
      end
      
    # private
      def source_section
        s_sec = {}
        s_sec = {:file => self.source_file, 
                 :parser => {:name => self.parser, 
                             :options => self.parser_options.to_hash
                            }
                }
        self.source_parameters.each {|k,v| s_sec[k] = v} unless self.source_parameters.nil?
        s_sec
      end
      
      def definition_section_array
        return [] if self.definition.nil?
      end
      
      def definition_section
        return {} if self.definition.nil?
        d_sec = {}
        self.definition.each {|k,v| d_sec[k] = v}
        d_sec
      end
      
    end
  end
end