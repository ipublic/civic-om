require 'mime/type'
module ApplicationHelper
  
  # def resource_name
  #   :user
  # end
  # 
  # def resource
  #   @resource ||= User.new
  # end
  # 
  # def devise_mapping
  #   @devise_mapping ||= Devise.mappings[:user]
  # end

  def mime_to_ext(mime_type)
    Mime::Type.file_extension_of(mime_type) || mime_type
  end
  
  def mixed_case(name)
    name.downcase.gsub(/\b\w/) {|first| first.upcase }
  end
  
  #transform true/false to yes/no strings
  def boolean_to_human(test)
    test ? "Yes" : "No"
  end
  
  def show_fields(object, field_list)
    res = field_list.inject("<table class='property-table'>") do |html, a_field|
      if a_field.is_a?(String)
        html+="<tr>" + show_field(object, a_field) + "</tr>"
      else
        html+="<tr>" + show_field(object, * a_field) + "</tr>" 
      end
    end
    res += "</table>"
    res.html_safe
  end

  def show_field (object, field_name, field_label=field_name.to_s.humanize)
    value = nil
    if object.respond_to?(:fetch)
      value = object.fetch(field_name.to_s,'')
    else
      value = object.attributes.fetch(field_name.to_sym,'')
    end

    # if value still empty, try an accessor method with field_name
    if value.blank?
      begin
        value = object.send(field_name.to_sym)
      rescue; end
    end

    if value.is_a?(Integer)
      "<th class='property-table'>#{field_label}:</th> <td>#{number_with_delimiter(value)}</td>"
    elsif value.is_a?(Bignum)
      "<th class='property-table'>#{field_label}:</th> <td>#{number_with_delimiter(value)}</td>"
    elsif value.is_a?(Date)
      "<th class='property-table'>#{field_label}:</th> <td>#{value.to_s(:full_date_only)}</td>"
    elsif value.is_a?(Time)
      "<th class='property-table'>#{field_label}:</th> <td>#{value.to_s(:full_date_only)}</td>"
    else
      "<th class='property-table'>#{field_label}:</th> <td>#{h(value)}</td>"
    end
  end
  
  
end
