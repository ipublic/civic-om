require 'etl'

module ETL
  module OpenMedia
    class ControlFile

      attr_accessor :data_file, :parser, :parser_options, :source_parameters, :definition
      
      
      def initialize(data_file, parser, options={})
        @data_file = data_file
        @parser = parser
        
        @parser_options || options[:parser_options]
        @source_parameters || options[:source_parameters]
        @definition || options[:definition]
      end
      
      def parser_options
        @parser_options ||= {}
      end
      
      def source_parameters
        return nil if @source_parameters.nil?
        @source_parameters.each {|k,v| s_sec[k] = v}
      end
      
      def write(file)
        dir = file.split(file.split(File::SEPARATOR).last).first
        FileUtils.mkdir_p dir unless Dir.exists? dir
        File.delete(file) if File.exists?(file)
        
        File.open(file, "w") {|f| f << self}
      end
      
      def to_s
        ctl = "source :in, "
        ctl << @source_section.to_s
        ctl << ",\n #{@definition_section.to_s}"
      end

      def source_section
        s_sec = {}
        s_sec = {:file => @data_file, 
                 :parser => {:name => @parser, 
                             :options => @parser_options.to_hash
                            }
                }
        @source_parameters unless @source_parameters.nil?
        s_sec
      end
      
      def definition_section
        return {} if @definition.nil?
        d_sec = {}
        @definition.each {|k,v| d_sec[k] = v}
        d_sec
      end
      
    end
  end
end