<script type="text/javascript">
    var jq = jQuery;
    var navigationIndex = 0;
    var categoryLabel = "Categories";
    
    jq( document ).ready(function() {
    
		jq('#searchText').focus();
		
        jq( "#date_filter_title" ).click(function() {
            jq( "#date_filter_options" ).toggle();
        });

        jq( "#date_filter_options" ).click(function(e) {
            jq( "#date_filter_options" ).hide();
            var txt = jq(e.target).text();
            jq("#date_filter_title").text(txt);
        });
        
        jq('#selectAll_categories').click(function (event) {
		    console.log(jq('.category_check'));
		    jq('.category_check').prop('checked', true);
		    return false;
		});
		
		jq('#deselectAll_categories').click(function (event) {
		    jq('.category_check').prop('checked', false);
		    return false;
		});
		
		//works for the first time
		//TODO should work after the second click
		jq('.select_one_category').click(function (event) {
		    console.log(jq('.select_one_category'));
		    jq('.category_check').prop('checked', false);
		    var id = (this.id).replace("select_", "");
		    jq("#"+id).prop('checked', true);
		    submitChartSearchFormWithAjax();
		    return false;
		});
		
		jq('#searchBtn').click(function(event) {
			submitChartSearchFormWithAjax();
			return false;
		});
		
		jq('#submit_selected_categories').click(function(event) {
			submitChartSearchFormWithAjax();
			return false;
		});
		
		jq('.filter_method').click(function(event) {
			return false;
		});
		
		jq('#searchText').keyup(function(key) {
			var searchText = document.getElementById('searchText');
			if ((key.keyCode >= 48 && key.keyCode <= 90) || key.keyCode != 13 || key.keyCode == 8) {//use numbers and letters plus backspace only
				delay(function(){
					if (searchText != "") {
						/* Do Nothing for Now
						jq(".obsgroup_view").empty();
					 	jq("#obsgroups_results").html('Press Enter to search.');
					 	OR submitChartSearchFormWithAjax();
					 	*/
				 	}
			    }, 1000 );
		    }
			return false;
		});
		
		jq('#category_dropdown').on('click', function(e){
		    jq('#filter_categories_categories').addClass('display_filter_onclick');
		});
		jq('#hide_categories').on('click', function(e){
		    jq('#filter_categories_categories').removeClass('display_filter_onclick');
		    return false;
		});
		
		jq('#time_dropdown').on('click', function(e){
		    jq('#filter_categories_time').toggleClass('display_filter_onclick');
		});
		
		jq('#location_dropdown').on('click', function(e){
		    jq('#locationOptions').toggleClass('display_filter_onclick');
		});
		
		jq('#provider_dropdown').on('click', function(e){
		    jq('#providersOptions').toggleClass('display_filter_onclick');
		});
		
		//Not yet working
		jq("input[type='checkbox'].category_check").change(function(){
		    var a = jq("input[type='checkbox'].category_check");
		    if(a.length == a.filter(":checked").length){
		        categoryLabel = "All Categories";
		        alert(categoryLabel);
		    } else {
		    	//TODO set to something like Diagnosis...
		    	categoryLabel = "Categories";
		    }
		    jq('#category_label').html(categoryLabel);
		});
		
		function submitChartSearchFormWithAjax() {
			var searchText = document.getElementById('searchText');
			
			//if (searchText.value != "") {
				 jq(".obsgroup_view").empty();
				 jq("#obsgroups_results").html('<img class="search-spinner" src="/openmrs/ms/uiframework/resource/uicommons/images/spinner.gif">');
				jq.ajax({
					type: "POST",
					 url: "${ ui.actionLink('getResultsFromTheServer') }",
					data: jq('#chart-search-form-submit').serialize(),
					dataType: "json",
					success: function(results) {
						jq(".inside_filter_categories").fadeOut(500);
						
						jsonAfterParse = JSON.parse(results);
						
						refresh_data();
						jq(".results_table_wrap").fadeIn(500);
						
						//click the first result to show its details at the right side
						jq('#first_obs_single').trigger('click');
						
						//show updated facets
						jq(".inside_filter_categories").fadeIn(500);
						
						jq('#searchText').focus();
					},
					error: function(e) {
					  //alert("Error occurred!!! " + e);
					}
				});
			//}
		}
		
		var delay = (function() {
		  var timer = 0;
		  return function(callback, ms){
		    clearTimeout (timer);
		    timer = setTimeout(callback, ms);
		  };
		})();
		
		jq(document).keydown(function(key) {
			//TODO update navigationIndex variable after load_single_detailed_obs(...)
			var single_obsJSON = jsonAfterParse.obs_singles;
			var obsId = single_obsJSON[navigationIndex].observation_id;
			
			if (typeof single_obsJSON !== 'undefined') {
				if(key.keyCode == 39) {// =>>
					if (navigationIndex >= 0) {
						navigationIndex++;
					}
					focusOnCurrentObsAndDisplayItsDetails(obsId);
				}
				if(key.keyCode == 37) {// <<=
					if (navigationIndex > 1) {
						navigationIndex--;
					}
					focusOnCurrentObsAndDisplayItsDetails(obsId);
				}
			}
		});
		
		function focusOnCurrentObsAndDisplayItsDetails(obsId) {
			//TODO not yet working to support verticle scrolling
			if(navigationIndex-1 == 0) {
				jq('#first_obs_single').focus();
			} else {
				jq('#obs_single_'+obsId).focus();
			}
			load_single_detailed_obs(obsId);
		}
    });
    
</script>

<style type="text/css">
    .chart-search-input {
        background: #00463f;
        text-align: left;
        color: white;
        padding: 20px 30px;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -o-border-radius: 5px;
        -ms-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;
    }
    .chart_search_form_text_input {
        min-width: 82% !important;
    }
    .inline {
        display: inline-block;
    }
    .chart_search_form_button {
        margin-left: 30px;
    }
    .form_label_style {
        margin-bottom: 10px !important;
    }
    .filter_options {
        display: none;
        background: white;
        width: 90px;
        padding: 13px;
        position: absolute;
        border: 1px solid black;
        left:242px;
    }
    .date_filter_title {
        display: inline-block;
        white-space: nowrap;
        background-color: #ddd;
        background-image: -webkit-gradient(linear, left top, left bottom, from(#eee), to(#ccc));
        background-image: -webkit-linear-gradient(top, #eee, #ccc);
        background-image: -moz-linear-gradient(top, #eee, #ccc);
        background-image: -ms-linear-gradient(top, #eee, #ccc);
        background-image: -o-linear-gradient(top, #eee, #ccc);
        background-image: linear-gradient(top, #eee, #ccc);
        border: 1px solid #777;
        padding: 0 1.5em;
        margin: 0.5em 0;
        font: bold 1em/2em Arial, Helvetica;
        text-decoration: none;
        color: #333;
        text-shadow: 0 1px 0 rgba(255,255,255,.8);
        -moz-border-radius: .2em;
        -webkit-border-radius: .2em;
        border-radius: .2em;
        -moz-box-shadow: 0 0 1px 1px rgba(255,255,255,.8) inset, 0 1px 0 rgba(0,0,0,.3);
        -webkit-box-shadow: 0 0 1px 1px rgba(255,255,255,.8) inset, 0 1px 0 rgba(0,0,0,.3);
        box-shadow: 0 0 1px 1px rgba(255,255,255,.8) inset, 0 1px 0 rgba(0,0,0,.3);
    }
    .date_filter_title:hover
    {
        background-color: #eee;
        background-image: -webkit-gradient(linear, left top, left bottom, from(#fafafa), to(#ddd));
        background-image: -webkit-linear-gradient(top, #fafafa, #ddd);
        background-image: -moz-linear-gradient(top, #fafafa, #ddd);
        background-image: -ms-linear-gradient(top, #fafafa, #ddd);
        background-image: -o-linear-gradient(top, #fafafa, #ddd);
        background-image: linear-gradient(top, #fafafa, #ddd);
        cursor: pointer;
    }

    .date_filter_title:active
    {
        -moz-box-shadow: 0 0 4px 2px rgba(0,0,0,.3) inset;
        -webkit-box-shadow: 0 0 4px 2px rgba(0,0,0,.3) inset;
        box-shadow: 0 0 4px 2px rgba(0,0,0,.3) inset;
        position: relative;
        top: 1px;
    }
    .date_filter_title:after {
        content:' ↓'
    }
    .single_filter_option {
        display: block;
        cursor: pointer;
    }

    .demo-container {
        box-sizing: border-box;
        width: 400px;
        height: 300px;
        padding: 20px 15px 15px 15px;
        margin: 15px auto 30px auto;
        border: 1px solid #ddd;
        background: #fff;
        background: linear-gradient(#f6f6f6 0, #fff 50px);
        background: -o-linear-gradient(#f6f6f6 0, #fff 50px);
        background: -ms-linear-gradient(#f6f6f6 0, #fff 50px);
        background: -moz-linear-gradient(#f6f6f6 0, #fff 50px);
        background: -webkit-linear-gradient(#f6f6f6 0, #fff 50px);
        box-shadow: 0 3px 10px rgba(0,0,0,0.15);
        -o-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        -ms-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        -moz-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        -webkit-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }

    .demo-placeholder {
        width: 100%;
        height: 100%;
        font-size: 14px;
        line-height: 1.2em;
    }

    .legend, .legend div {
        display: none;
    }

    .bold {
        font-weight: bold;
    }
    
    .category_filter_item {
    
    }
    
    .search-spinner {
    	display: block;
   		margin-left: auto;
    	margin-right: auto;
    	padding-top: 230px;
    	height:120px;
    	width:120px;
    }
    
    #found_no_results {
    	text-align:center;
    	font-size: 25px;
    }

</style>

<article id="search-box">
    <section>
        <div class="chart-search-wrapper">
            <form class="chart-search-form" id="chart-search-form-submit">
                <div class="chart-search-input">
                    <div class="chart_search_form_inputs">
                        <input type="text" name="patientId" id="patient_id" value=${patientId} hidden>
                        <input type="text" id="searchText" name="phrase" class="chart_search_form_text_input inline ui-autocomplete-input" placeholder="${ ui.message("chartsearch.messageInSearchField") }" size="40">
                        <input type="submit" id="searchBtn" class="button inline chart_search_form_button" value="search"/>
                    </div>
                    <div class="filters_section">
                    	<div class="dropdown" id="category_dropdown">
	                     	<div class="inside_categories_filter">
								<span class="dropdown-name" id="categories_label">
								<a href="#" class="filter_method">All Categories</a>
								<i class="icon-sort-down" id="icon-arrow-dropdown"></i>
								</span>
								<div class="filter_categories" id="filter_categories_categories">
									<a href="" id="selectAll_categories" class="disabled_link">Select All</a>&nbsp&nbsp&nbsp<a href="" id="deselectAll_categories" class="disabled_link">Deselect All</a>
									<br /><hr />
									<div id="inside_filter_categories">
										<script type="text/javascript">
											displayCategories(jsonAfterParse);
										</script>
									</div>
									<hr />
									<input id="submit_selected_categories" type="submit" value="OK" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<a href="" id="hide_categories">Hide</a>
								</div>
							</div>
						</div>
                        <div class="dropdown" id="time_dropdown">
                            <div class="inside_categories_filter">
                                <span class="dropdown-name" id="time_label">
                                    <a href="#" class="filter_method" id="time_anchor">Any Time</a>
                                    <i class="icon-sort-down" id="icon-arrow-dropdown"></i>
                                </span>
                                <div class="filter_categories" id="filter_categories_time">
                                    <hr />
                                        <a class="single_filter_option" onclick="time_filter(1, 'Last Day')">Last Day</a>
                                        <a class="single_filter_option" onclick="time_filter(7, 'Last Week')">Last Week</a>
										<a class="single_filter_option" onclick="time_filter(14, 'Last 2 Weeks')">Last 2 Weeks</a>
                                        <a class="single_filter_option" onclick="time_filter(31, 'Last Month')">Last Month</a>
										<a class="single_filter_option" onclick="time_filter(93, 'Last 3 Months')">Last 3 Months</a>
                                    <a class="single_filter_option" onclick="time_filter(183, 'Last 6 Months')">Last 6 Months</a>
                                        <a class="single_filter_option" onclick="time_filter(365, 'Last Year')">Last Year</a>
                                        <a class="single_filter_option" onclick="refresh_data()">Any Time</a>
                                </div>
                            </div>
                        </div>
                        <div class="dropdown" id="location_dropdown">
                            <div class="inside_categories_filter">
                                <span class="dropdown-name" id="categories_label">
                                    <a href="#" class="filter_method" id="location_anchor">All Locations</a>
                                    <i class="icon-sort-down" id="icon-arrow-dropdown"></i>
                                </span>
                                <div class="filter_categories" id="locationOptions">

                                </div>
                            </div>
                        </div>
                        <div class="dropdown" id="provider_dropdown">
                            <div class="inside_categories_filter">
                                <span class="dropdown-name" id="categories_label">
                                    <a href="#" class="filter_method" id="provider_anchor">All Providers</a>
                                    <i class="icon-sort-down" id="icon-arrow-dropdown"></i>
                                </span>
                                <div class="filter_categories" id="providersOptions">
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
    			${ ui.includeFragment("chartsearch", "main_results") }
            </form>
        </div>
    </section>
</article>