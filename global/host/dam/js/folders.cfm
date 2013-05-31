<script language="javascript">
	// when saving sharing only
	function savesharing(theid,iscol){
		var url = formaction("form_folder_share" + theid);
		var items = formserialize("form_folder_share" + theid);
		// Submit Form
       	$.ajax({
			type: "POST",
			url: url,
		   	data: items,
		   	success: function(theid,iscol){
				// Feedback
				$('#updatetextshare').html('<cfoutput>#JSStringFormat(myFusebox.getApplicationData().defaults.trans("success"))#</cfoutput>');
				$("#updatetextshare").animate({opacity: 1.0}, 3000).fadeTo("slow", 0);
		   	}
		});
	}
	// when saving folder
	function foldersubmit(theid,isdetail,iscol,noreload,nocheck){
		// If nocheck is undefined then simply execute the check of the foldername
		if (nocheck != true){
			var checkfolder = $('#folder_name').val();
			if (checkfolder == ""){
				alert('Please enter name!');
				return false;
			}
		}
		// If nocheck is true then it means user wants to establish link
		if (nocheck == true){
			var checklink = $('#link_path').val();
			if (checklink == ""){
				alert('Please enter an absolute path!');
				return false;
			}
		}
		// $("body").append('<div id="bodyoverlay"><img src="' + dynpath + '/global/host/dam/images/loading-bars.gif" border="0" style="padding:10px;"></div>');
		var url = formaction("form_folder" + theid);
		var items = formserialize("form_folder" + theid);
		//alert(iscol);
		// If ID is empty
		if(theid == ""){
			theid = 0;
		}
		if(iscol == "F"){
			// Submit Form
	       	$.ajax({
				type: "POST",
				url: url,
			   	data: items,
			   	success: function(data, textStatus, jqXHR){
			   		// Set var for the folderid and trim it
			   		var fid = trim(data);
					// Jump into the folder
					if (isdetail == 'F'){
						$('#rightside').load('index.cfm?fa=c.folder&col=F&folder_id=' + fid);
					}
					else{
						$('#updatetext').html('<cfoutput>#JSStringFormat(myFusebox.getApplicationData().defaults.trans("success"))#</cfoutput>');
					}
					// Remove loader
					// $("#bodyoverlay").remove();
					// Reload Explorer
					if (noreload != true) $('#explorer').load('index.cfm?fa=c.explorer');
			   	}
			});
		}
		else {
			// Submit Form
	       	$.ajax({
				type: "POST",
				url: url,
			   	data: items,
			   	success: function(data, textStatus, jqXHR){
			   		// Set var for the folderid and trim it
			   		var fid = trim(data);
					// Jump into the folder
					if (isdetail == 'F'){
						$('#rightside').load('index.cfm?fa=c.collections&col=T&folder_id=col-' + fid);
					}
					else{
						$('#updatetext').html('<cfoutput>#JSStringFormat(myFusebox.getApplicationData().defaults.trans("success"))#</cfoutput>');
					}
					// Remove loader
					// $("#bodyoverlay").remove();
					// Reload Explorer
					$('#explorer_col').load('index.cfm?fa=c.explorer_col');
			   	}
			});
		}
        return false; 
	}
	function reloadexplorer(theid,isdetail,iscol){
		// If ID is empty
		if(theid == ""){
			theid = 0;
		}
		// Reload Explorer
		$('#explorer').load('index.cfm?fa=c.explorer');
		// Show the update feedback
		document.getElementById('updatetext').style.visibility = "visible";
		$("#updatetext").html('<cfoutput>#JSStringFormat(myFusebox.getApplicationData().defaults.trans("success"))#</cfoutput>');
		$("#updatetext").animate({opacity: 1.0}, 3000).fadeTo("slow", 0);
	}
	// Set today date into form fields
	function settoday(theform,fd) {
		<cfset settodayd = day(now())>
		<cfset settodaym = month(now())>
		$('#' + theform + ' [name="' + fd + '_day"]').val('<cfoutput><cfif len(settodayd) EQ 1>0</cfif>#settodayd#</cfoutput>');
		$('#' + theform + ' [name="' + fd + '_month"]').val('<cfoutput><cfif len(settodaym) EQ 1>0</cfif>#settodaym#</cfoutput>');
		$('#' + theform + ' [name="' + fd + '_year"]').val('<cfoutput>#year(now())#</cfoutput>');
	}
	// For search
	function subadvfields(theform){
		// Get values
		var searchtext = '';
		var searchfor = document.forms[theform].searchfor.value.replace(/["']/g, '\\"');
		var keywords = document.forms[theform].keywords.value.replace(/["']/g, '\\"');
		var description = document.forms[theform].description.value.replace(/["']/g, '\\"');
		var filename = document.forms[theform].filename.value.replace(/["']/g, '\\"');
		var extension = document.forms[theform].extension.value.replace(/["']/g, '\\"');
		var rawmetadata = document.forms[theform].rawmetadata.value.replace(/["']/g, '\\"');
		var labels = $('#' + theform + ' [name="labels"]').val();
		if(labels != null) var labels = labels.toString().replace(/,/g, " ");
		var andor = document.forms[theform].andor.options[document.forms[theform].andor.selectedIndex].value;
		// Custom fields (get values)
		<cfloop query="qry_cf_fields"><cfset cfid = replace(cf_id,"-","","all")><cfoutput>
			<cfif cf_type EQ "text" OR cf_type EQ "textarea">
				var value_#cfid# = document.forms[theform].cf#cfid#.value.split(' ').join(' +').replace(/["']/g, '\\"');
			<cfelseif cf_type EQ "select">
				var value_#cfid# = document.forms[theform].cf#cfid#.options[document.forms[theform].cf#cfid#.selectedIndex].value.split(' ').join(' +');
			<cfelseif cf_type EQ "radio">
				var oRadio = document.forms[theform].elements['cf#cfid#'];
				for(var i = 0; i < oRadio.length; i++){
				  if(oRadio[i].checked){
				     var value_#cfid# = oRadio[i].value.split(' ').join(' +');
				  }
				}
			</cfif>
		</cfoutput></cfloop>
		// Put together the search
		if (labels == null) var labels = '';
		if (searchfor != '') var searchfor = searchfor;
		if (keywords != '') var keywords = 'keywords:' + keywords;
		if (description != '') var description = 'description:' + description;
		if (filename != '') var filename = 'filename:' + filename;
		if (extension != '') var extension = 'extension:' + extension;
		if (rawmetadata != '') var rawmetadata = 'rawmetadata:' + rawmetadata;
		if (labels != ''){
			if (andor == "OR"){
				var labels = 'labels:(' + labels + ')';
			}
			else {
				var con1 = '\+';
				var con2 = labels.split(' ').join(' +');
				var labels = 'labels:(' + con1.concat(con2) + ')';
			}
		}
		// Custom fields (Put together and prefix with custom field id)
		<cfloop query="qry_cf_fields"><cfset cfid = replace(cf_id,"-","","all")><cfoutput>
			<cfif cf_type EQ "text" OR cf_type EQ "textarea">
				if (value_#cfid# != '') var value_#cfid# = 'customfieldvalue:(+#cf_id# +' + value_#cfid# + ')';
			<cfelse>
				if (value_#cfid# != '') var value_#cfid# = 'customfieldvalue:(+#cf_id#+' + value_#cfid# + ')';
			</cfif>
		</cfoutput></cfloop>
		// Create the searchtext
		var searchtext = searchfor;
		if (searchtext != '' && keywords != '') {
			var searchtext = searchtext + ' ' + andor + ' ' + keywords;
		}
		else {
			var searchtext = searchtext + keywords;
		}
		if (searchtext != '' && description != '') {
			var searchtext = searchtext + ' ' + andor + ' ' + description;
		}
		else {
			var searchtext = searchtext + description;
		}
		if (searchtext != '' && filename != '') {
			var searchtext = searchtext + ' ' + andor + ' ' + filename;
		}
		else {
			var searchtext = searchtext + filename;
		}
		if (searchtext != '' && extension != '') {
			var searchtext = searchtext + ' ' + andor + ' ' + extension;
		}
		else {
			var searchtext = searchtext + extension;
		}
		if (searchtext != '' && rawmetadata != '') {
			var searchtext = searchtext + ' ' + andor + ' ' + rawmetadata;
		}
		else {
			var searchtext = searchtext + rawmetadata;
		}
		if (searchtext != '' && labels != '') {
			var searchtext = searchtext + ' ' + andor + ' ' + labels;
		}
		else {
			var searchtext = searchtext + labels;
		}
		// Custom fields (add to the searchtext)
		<cfloop query="qry_cf_fields"><cfset cfid = replace(cf_id,"-","","all")><cfoutput>
			// Check that value is not undefined
			t = value_#cfid#.indexOf("undefined");
			if (t == '-1'){
				if (searchtext != '' && value_#cfid# != '') {
					var searchtext = searchtext + ' ' + andor + ' ' + value_#cfid#;
				}
				else {
					var searchtext = searchtext + value_#cfid#;
				}
			}
		</cfoutput></cfloop>
		return searchtext;
	}
	//for sync folder
	function syncfolder(theid,isdetail,iscol){
		// Reload Explorer
		$('#explorer').load('index.cfm?fa=c.explorer');
		// Show the update feedback
		$("#synupdatetext").css({visibility: 'visible'});
		$("#synupdatetext").animate({opacity: 1.0}, 3000).fadeTo("slow", 0);
	}
</script>