// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require_tree .


var darkmode = false;

$(document).on('turbolinks:load', startup);

function setDarkMode() {
    if (darkmode) {
        $(document.body).addClass('darkmode');
    } else {
        $(document.body).removeClass('darkmode');
    }
    localStorage.setItem('darkmode', darkmode ? '1' : '0');
}

function startup() {
    darkmode = localStorage.getItem('darkmode') === '1' ? true : false;
    setDarkMode();
    $('#darkmodetoggle').click(function () {
        console.log(darkmode);
        darkmode = !darkmode;
        setDarkMode();
    });

    setupSignupPage();
    setupCreateNewWallet();
    setUpTransaction();
}

function setupCreateNewWallet() {
    $("#wallet_form_name").on('input', function () {
        $(".icon-wallet-name").html($(this).val());
    });
}

function setupSignupPage() {
    $('#signupform')?.submit(function (e) {
        let p1 = $('#password').val();
        if (p1.length < 6) {
            $('#submit_btt').disable = false;
            e.preventDefault();
        }
        if (p1 != $('#password_repeat').val()) {
            $('#submit_btt').disable = false;
            e.preventDefault();
        }
    });

    $('#password').change(function() {
        let val = $(this).val();
        if (val.length < 6) {
            $(this).addClass("form-fail");
            $('#password_not_meat_minimum').show();
        } else {
            $(this).removeClass("form-fail");
            $('#password_not_meat_minimum').hide();
        }
    });

    $('#password_repeat').change(function() {
        let val = $(this).val();
        let p1 = $('#password').val();
        if (p1 != val) {
            $(this).addClass("form-fail");
            $('#password_not_match').show();
        } else {
            $(this).removeClass("form-fail");
            $('#password_not_match').hide();
        }
    });
}

function setUpTransaction() {
    let origin = "#transaction_origin_id";
    let destination = "#transaction_destination_id";
    $('#transaction_form').submit(function (e) {
        if ($(origin).val() == $(destination).val()) {
            $('#destination_same').show();
            $(destination).addClass('form-fail');
            // By this point for some reason the button is not disabled yet so this timeout
            // will wait for the button to be disabled so it can reenable it again
            setTimeout(() => {
                document.getElementById('submit_btt').disabled = false;
                //$('#submit_btt').disabled = false;
            }, 100);
            e.preventDefault();
        } else {
            $('#destination_same').hide();
            $(destination).removeClass('form-fail');
        }
    });
    $(destination).change(function () {
        if ($(origin).val() == $(this).val()) {
            $('#destination_same').show();
            $(destination).addClass('form-fail');
        } else {
            $('#destination_same').hide();
            $(destination).removeClass('form-fail');
        }
    });
}

// This function will change the path of the window to the desired location
function moveTo(target) {
    //console.log(target);
    //window.location.href = target;
    //window.location.reload();
    window.location = target;
}
