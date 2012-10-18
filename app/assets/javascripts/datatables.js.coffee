jQuery ->

  # Table initialisation
  $(document).ready ->
    $.extend $.fn.dataTable.defaults,
      iDisplayLength: 100

    sdtable = $("#new-status").dataTable
      sDom:"<'row'<'span6'<'dt_actions'>l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
      sPaginationType: "bootstrap"

      oLanguage:
        sLengthMenu: "_MENU_ records per page"
        sSearch: "Search:"

      aoColumnDefs : [
        bSortable: false
        aTargets: ['unsortable']
      ]
      aaSorting: [[ 3, "asc" ]]
      bFilter: true
      bPaginate: true
      bStateSave: true
      bProcessing: true
      bServerSide: true
      sAjaxSource: $('#new-status').data('source')

    table = $("#location-table").dataTable
      sDom: "<'row'<'span3'l><'span3-5 right'f>r>t<'row'<'span3'i><'span4'p>>"
      sPaginationType: "bootstrap"

      oLanguage:
        sLengthMenu: "_MENU_ records per page"
        sSearch: "Search: <a href='#' rel='tooltip' data-original-title='You can search by Name, Address, Zipcode, or Region. In order to search by a region, use r: followed by the region numbers separated by commas. For example r: 4,5 to search only regions 4 and 5.'><i class='icon-info-sign icon-inline'></i></a>"

      aoColumnDefs : [
        bSortable: false
        aTargets: ['unsortable']
      ]
      aaSorting: [[ 3, "desc" ]]
      bFilter: true
      bPaginate: true
      bStateSave: true
      bProcessing: true
      bServerSide: true
      sAjaxSource: $('#location-table').data('source')

    table.$("a[rel=tooltip]").tooltip('show').hover (e) ->
      e.preventDefault()
