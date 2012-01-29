// Dashboard Admin
	$('a.add-measure-group').live('click',
	function() {
	    var link = this;
	    $.get($(link).attr("data-url"),
	    function(html) {
	        $(html).insertBefore(link);
	        $('a.add-element').button({
	            icons: {
	                primary: "ui-icon-circle-plus"
	            }
	        });
	        $('a.delete-element').button({
	            icons: {
	                primary: "ui-icon-circle-close"
	            },
	            text: false
	        });
	    });
	    return false;
	});

    $('a.delete-dashboard-group').live('click', function() {
			// $(this).closest('div').next('div').remove();
			$(this).closest('.dashboard-measure-group').remove();
			return false;
    });

    $('a.delete-measure').live('click', function() {
	$(this).closest('table').remove();
	return false;
    });

    var dashboardClassAutoCompleteOpts = {delay: 300,
					  mustMatch: true,
					  source: "/admin/schema/classes/autocomplete",
					  select: function(event, ui) {
					      var classURI = ui.item.id;
					      $(event.target).next('input').val(classURI);
					      $.getJSON('/admin/schema/classes/property_list?class_uri='+classURI, function(data) {
						  $(event.target).closest('table').find('input.dashboard-property').autocomplete({source: data});
					      });

					  }};

    // setup property autocomplete for all measures with class set
    $('.dashboard-source-class').each(function() {
	var classURI = $(this).next().val();
	var sourceClassInput = this;
	if (classURI != '' && classURI != null) {
	    $.getJSON('/admin/schema/classes/property_list?class_uri='+classURI, function(data) {
		$(sourceClassInput).closest('table').find('input.dashboard-property').autocomplete({source: data});
	    });
	}
    });

    $('a.add-measure').live('click', function() {
	var link = this;
	$.get('/admin/dashboards/new_measure', function(html) {
	    $(html).insertBefore(link);
	    $(link).prev().find('.dashboard-source-class').autocomplete(dashboardClassAutoCompleteOpts);
	    $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});
	    $('a.delete-element').button({icons: {primary: "ui-icon-circle-close"}, text: false});    
	});
	return false;
    });
    $('.dashboard-source-class').autocomplete(dashboardClassAutoCompleteOpts);


    // basic button styling
    $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});
    $('a.delete-element').button({icons: {primary: "ui-icon-circle-close"}, text: false});    
    $('.datasource-class').autocomplete(typeAutoCompleteOpts);
    $('.property-type-uri').autocomplete(typeAutoCompleteOpts);
    $('.property-range-uri').autocomplete(typeAutoCompleteOpts);
    $('.datasource-class-uri').autocomplete(typeAutoCompleteOpts);

    $('#source input.property-name').live('blur', syncSourceProperties);
    $('.tooltip').tooltip();

    $('input.named-place').autocomplete({
	delay: 300,
	mustMatch: true,
	source: "/sites/autocomplete_geoname",
	select: function(event, ui) {
	    $(event.target).closest('fieldset').find('.named-place-id').val(ui.item.id);
	}
    });
