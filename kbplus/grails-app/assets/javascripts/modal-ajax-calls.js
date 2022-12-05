$('a[id=addCoreDates]').click(function() {
		$.ajax({
			type: "GET",
			url: "/ajax/test"
		}).done(function(data) {
			console.log(data);
			//$('.modal-content').html(data);
		});
	});

