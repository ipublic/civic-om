class RawRecordsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end
  

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: RawRecord.count,
      iTotalDisplayRecords: raw_records.total_entries,
      aaData: data
    }
  end

private

  def data
    raw_records.map do |raw_record|
      [
        link_to(raw_record.name, raw_record),
        h(raw_record.category),
        h(raw_record.released_on.strftime("%B %e, %Y")),
        number_to_currency(RawRecord.price)
      ]
    end
  end

  def raw_records
    @raw_records ||= fetch_raw_records
  end

  def fetch_raw_records
    raw_records = records.collect{|rr| @data_source.source_properties.collect{|p| rr[p.identifier]}}
    # raw_records = RawRecord.order("#{sort_column} #{sort_direction}")

    raw_records = raw_records.page(page).per_page(per_page)
    if params[:sSearch].present?
      raw_records = raw_records.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    raw_records
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end