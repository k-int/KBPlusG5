<div class="container" data-theme="subscriptions">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text center">Choose Export Type</h1>
	    	<div class="row">
			  	<div class="launch-item-container">
			  		<g:link class="launch-item" controller="myInstitutions" action="currentSubscriptions" params="${params + [format:'json', max:0]}">
				  		<div class="content">
				  			<i class="large material-icons">file_download</i>
				  			<div class="title">JSON</div>
			  			</div>
			  		</g:link>
		      	</div>
		    	<div class="launch-item-container">
			      	<g:link class="launch-item" controller="myInstitutions" action="currentSubscriptions" params="${params + [format:'xml', max:0]}">
					  	<div class="content">
					  		<i class="large material-icons">file_download</i>
				  			<div class="title">XML</div>
			  			</div>
			  		</g:link>
		      	</div>
			    <div class="launch-item-container">
			    	<g:link class="launch-item" controller="myInstitutions" action="currentSubscriptions" params="${params + [format:'csv', max:0]}">
						<div class="content">
						  	<i class="large material-icons">file_download</i>
					  		<div class="title">CSV</div>
				  		</div>
				  	</g:link>
			    </div>
			</div>
  		</div>
  	</div>
</div>
