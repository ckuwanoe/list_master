class ListsDatatable
  delegate :params, :h, :link_to, :raw, :number_with_precision, to: :@view

  def initialize(view)
    @view = view
    @current_user = User.current
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: List.count,
      iTotalDisplayRecords: lists.total_count,
      aaData: data
    }
  end

private

  def data
    lists.map do |list|
      array = [
        raw("<input type='checkbox' name='list_ids[]'' value='#{list.id}''>"),
        list.list_name,
        list.van_list_id,
        list.county,
        list.region_name,
        list.precinct_number,
        list.current_status,
        list.latest_status
      ]
    end
  end

  def lists
    @lists ||= fetch_lists
  end

  def fetch_lists
    lists = List.region_and_status_join.order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      search = params[:sSearch].gsub("'","")
      if search.match(/^[r][ ]*[:][ ]*[0-9 ]+/i)
        lists = lists.where("list_name ILIKE :search OR regions.region_name ILIKE :search OR precincts.county ILIKE :search
          OR precincts.precint_number ILIKE :search OR van_list_id ILIKE :search", search: "%#{search}%")
      end
    end
    lists = Kaminari.paginate_array(lists).page(page).per(per_page)
    return lists
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[ list_name distance van_list_id county region_name precinct_number current_status latest_status]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
