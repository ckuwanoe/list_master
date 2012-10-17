jQuery ->
  $('#dp1').datepicker ->
    format: 'mm/dd/yyyy'
    onClose: closeDate = (dateText, inst) ->  $(inst.input).change().focusout()
    changeMonth: true
    changeYear: true
