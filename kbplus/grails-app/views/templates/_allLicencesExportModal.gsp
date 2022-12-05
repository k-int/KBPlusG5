<div class="container" data-theme="licences">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text center">Choose Export Type</h1>
	    	<div class="row">
	    		<div class="launch-item-container">
			  		<g:link class="launch-item" controller="dataManager" action="allLicenses" params="${params + [format:'json']}">
				  		<div class="content">
				  			<i class="large material-icons">file_download</i>
				  			<div class="title">JSON</div>
			  			</div>
			  		</g:link>
		      	</div>
		    	<div class="launch-item-container">
			      	<g:link class="launch-item" controller="dataManager" action="allLicenses" params="${params + [format:'xml']}">
					  	<div class="content">
					  		<i class="large material-icons">file_download</i>
				  			<div class="title">XML</div>
			  			</div>
			  		</g:link>
		      	</div>
			  	<div class="launch-item-container">
			  		<g:link class="launch-item" controller="dataManager" action="allLicenses" params="${params+[format:'csv']}">
				  		<div class="content">
				  			<i class="large material-icons">file_download</i>
				  			<div class="title">CSV Export</div>
			  			</div>
			  		</g:link>
		      	</div>
			</div>
  		</div>
  	</div>
</div>