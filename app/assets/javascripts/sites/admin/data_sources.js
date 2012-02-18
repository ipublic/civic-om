$(document).ready(function() {
    $('#raw-data-table').dataTable({
														      'bFilter': false,
														      'bScrollCollapse': true,
																	'bScrollInfinite': true,
													        "bPaginate": false,
													        // "bLengthChange": false,
													        "bFilter": true,
													        "bSort": false,
													        "bInfo": true,
													        "bAutoWidth": true,
																	// 'sScrollXInner': '110%',
														      'sScrollX': '100%',
																	'sScrollY': '600px',
														      'bSort': false,
																	'bJQueryUI': true,
																	// 														      'bProcessing': true,
																	// 														      'bServerSide': true,
														      'sPaginationType': 'full_numbers'
});
} );
