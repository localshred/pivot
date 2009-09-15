$(document).ready(function(){
	$("input[name='clear_original_target_date']:checkbox").click(function(){
		if ($(this).attr("checked"))
		{
			$("#original-date-display").hide();
			$("#original-date-input").show();
			$("#original-date-input input").select();
		}
	});
});