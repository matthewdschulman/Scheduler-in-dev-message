// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

$(document).ready(function(){
    $('#home-sign-up').click(function(){
	$('#home-log-in-pane').addClass('hide');
	$('#home-sign-up-pane').removeClass('hide');
	$('#home-sign-up-pane').removeClass('fade');
    });

    $('#sign-up-back').click(function(){
	$('#home-sign-up-pane').addClass('hide');
	$('#home-log-in-pane').removeClass('hide');
	$('#home-log-in-pane').removeClass('fade');
    });

    $('#sign-up-bank-password, #sign-up-bank-account').keyup(function(){
	var passwd_len = $('#sign-up-bank-password').val().length
	var user_len = $("#sign-up-bank-account").val().length
	if (passwd_len > 4 && user_len > 3)
	    $("#sign-up-verify-bank").removeClass('disabled');
	else
	    $("#sign-up-verify-bank").addClass('disabled');
    });

    $('#sign-up-verify-bank').click(function(){
	event.preventDefault();
	var type = $('#sign-up-bank').val();
	var username = $('#sign-up-bank-account').val();
	var password = $('#sign-up-bank-password').val();
	var email = $('#sign-up-email').val();

	req = "/add_user?type=" + type + "&username=" + username +
	"&password=" + password + "&email=" + email;

	console.log(req);

	function failMFA(data) {
	    console.log(data)
	}

	function stepMFA(data) {
	    console.log(data);
	    var code = data['code']
	    var type = data['type']
	    if (code == 201) {
		var question = data['question']
		$('#security-question').text(data['question']);
		$('#security-modal').modal('show');

		$('#security-answer-submit').click(function(){
		    event.preventDefault();
		    var token = data['access_token'];
		    var mfa = $('#security-answer').val();
		    if (mfa.length > 0)
		    {
			var req = '/mfa_step?mfa=' + mfa + '&access_token=' + token;
			$('#security-modal').modal('hide');
			$('#security-answer').val('');
			$.get(req).done(stepMFA).fail(failMFA);
		    }
		})
	    }
	    else if (code == 200) {
		$('#bank-form-group input, #bank-form-group select').prop('disabled', true);
		$('#sign-up-verify-bank').addClass('disabled');
		$('#sign-up-submit').removeClass('disabled');
		$('#sign-up-access-token').val(data['access_token']);
	    }
	    else {
		// Something went terribly wrong
	    }
	}


	$.get(req)
	    .done(stepMFA)
	    .fail(function(data) {
		alert('Fail', data);
	    });

    });


});

function checkEquality() {
  if($("#inputPassword").val() == $("#inputPasswordConf").val() && $("#inputPassword").val().length > 5) {
    $("#glyphCheck").css("display", "block");
    $("#glyphX").css("display", "none");
  }
  else {
    $("#glyphX").css("display", "block");
    $("#glyphCheck").css("display", "none");
  }
}
