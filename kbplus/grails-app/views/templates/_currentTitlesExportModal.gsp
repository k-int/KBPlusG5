<div class="container" data-theme="titles">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text center">Choose Export Type</h1>
	    	<div class="row">
	    		<div class="launch-item-container">
			  		<g:link class="launch-item" controller="myInstitutions" action="currentTitles" id="${params.id}" params="${params + [format:'csv']}">
				  		<div class="content">
				  			<i class="large material-icons">file_download</i>
				  			<div class="title">CSV</div>
			  			</div>
			  		</g:link>
		      	</div>
			  	<div class="launch-item-container">
			  		<g:link class="launch-item" controller="myInstitutions" action="currentTitles" id="${params.id}" params="${params + [format:'json']}">
				  		<div class="content">
				  			<i class="large material-icons">file_download</i>
				  			<div class="title">JSON</div>
			  			</div>
			  		</g:link>
		      	</div>
		    	<div class="launch-item-container">
			      	<g:link class="launch-item" controller="myInstitutions" action="currentTitles" id="${params.id}" params="${params + [format:'xml']}">
					  	<div class="content">
					  		<i class="large material-icons">file_download</i>
				  			<div class="title">XML</div>
			  			</div>
			  		</g:link>
		      	</div>
		      	<g:each in="${transforms}" var="transkey,transval">
			    	<div class="launch-item-container">
			    		<g:link class="launch-item" controller="myInstitutions" action="currentTitles" id="${params.id}" params="${params + [format:'csv',transformId:transkey,mode: params.mode, defaultInstShortcode:params.defaultInstShortcode]}">
						  	<div class="content">
						  		<i class="large material-icons">file_download</i>
					  			<div class="title">${transval.name}</div>
				  			</div>
				  		</g:link>
			      	</div>
				</g:each>
			</div>
  		</div>
  	</div>
</div>