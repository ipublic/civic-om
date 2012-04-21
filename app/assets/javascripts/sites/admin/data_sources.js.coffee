jQuery ->
	$('#raw-data-table').dataTable
		sPaginationType: "full_numbers"
		bScrollCollapse: true
		bScrollInfinite: true
		# bPaginate: false
		# bLengthChange: false
		bFilter: true
		bInfo: true
		bAutoWidth: true
		# sScrollXInner: "110%"
		sScrollX: "100%"
		sScrollY: "600px"
		bSort: false
		bJQueryUI: true
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#datasource').data('source')
