# code courtesy of http://blog.choonkeat.com/weblog/2007/02/retrieving-a-se.html
# Registration example
# Mime::Type.register "text/vnd.sun.j2me.app-descriptor", :jad
# Mime::Type.file_extension_of "text/vnd.sun.j2me.app-descriptor"  # => "jad"

module Mime
  class Type
    class << self
      # Lookup, guesstimate if fail, the file extension
      # for a given mime string. For example:
      #
      # >> Mime::Type.file_extension_of 'text/rss+xml'
      # => "xml"
      def file_extension_of(mime_string)
          set = Mime::LOOKUP[mime_string]
          sym = set.instance_variable_get("@symbol") if set
          return sym.to_s if sym
          return $1 if mime_string =~ /(\w+)$/
      end
    end
  end
end
