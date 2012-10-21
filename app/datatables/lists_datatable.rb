class ListsDatatable
  delegate :params, :h, :link_to, :raw, :number_with_precision, to: :@view
  #include 'ActionView::Helpers'
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
        raw("<input type='checkbox' name='list_ids[]'' value='#{list.id}'' class='checked'>"),
        list.list_name,
        list.turf_number,
        "#{(list.precinct_density.to_f * 100).round(2)}%",
        list.doors_count,
        list.two_days_ago,
        list.one_day_ago,
        raw("<span class='today'>#{list.today}</span>"),
        list.one_day_from_now,
        list.two_days_from_now
      ]
    end
  end

  def lists
    @lists ||= fetch_lists
  end

  def fetch_lists
    lists = List.get_all_lists_by_day_for_five_days(nil,nil)#.order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      search_string = params[:sSearch].gsub("'","")
      #if search_string.match(/^[r][ ]*[:][ ]*[0-9 ]+/i)
      if search_string.match(/^[0-9 ]+/i) # if the search string is numeric only
        lists = List.get_all_lists_by_day_for_five_days(nil,"WHERE precincts.precinct_number::VARCHAR LIKE '%#{search_string}%'")
      else
        lists = List.get_all_lists_by_day_for_five_days(nil,"WHERE list_name ILIKE '%#{search_string}%' OR precincts.county ILIKE '%#{search_string}%'")
      end
    end
    lists = Kaminari.paginate_array(lists).page(page).per(per_page)
    return lists
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column
    columns = %w[ list_name van_list_id precinct_number turf_number county region_name doors_count precinct_density current_status latest_status]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
