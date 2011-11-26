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
      property :source_type, [String], :read_only => true, :default => %W[file database url]
      property :source_file, String
      property :parser, String
      property :parser_options, :default => {}
      
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
        klass_names = parent_class.descendants.map {|k| k.to_s.demodulize}.sort
        list = {}
        klass_names.each do |kn|
          k = kn.split("Parser").first.downcase
          list[k] = kn.titleize
        end
        list
      end

      def to_s
        # "source :in, {\n  :file => '#{self.source_file}',\n  :parser => {\n :name => #{self.parser},\n  :options => #{self.parser_options}\n }\n}"
        "source :in, {\n  :file => '#{self.source_file}',\n  :parser => {\n :name => :#{self.parser},\n  :options => #{self.parser_options}\n }\n}"
      end

      def write(file)
        dir = file.split(file.split(File::SEPARATOR).last).first
        FileUtils.mkdir_p dir unless Dir.exists? dir
        File.delete(file) if File.exists?(file)
        f = File.new(file, "w")
        f.write(self.to_s)
        f.close
      end
      
    end
  end
end