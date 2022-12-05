<script type="text/javascript">
	function addHiddenAnchorParam(theForm, value) {
    	var input = document.createElement('input');
    	input.type = 'hidden';
    	input.name = 'anchor';
    	input.value = value;
    	theForm.appendChild(input);
	}
	
	var theForm = document.forms["${formName}"];
	var loc = window.location.href;
	if (loc.indexOf("#") !== -1) {
		var anc = loc.substring(loc.indexOf("#"), loc.length);
		addHiddenAnchorParam(theForm, anc);
	}
</script>