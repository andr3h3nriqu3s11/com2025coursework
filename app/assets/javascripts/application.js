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
$(document).on('turbolinks:before-visit', function () {
    $(document.body).removeClass("loaded")
});

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

    window.requestAnimationFrame(() => {
        $(document.body).addClass("loaded")
    });

    setupSignupPage();
    setupCreateNewWallet();
    setUpTransaction();
    setUpHome();
    setUpQuickLink();
}
var initial = "";
function setupCreateNewWallet() {
    $("#wallet_form_name").on('input', function () {
        $(".icon-wallet-name").html($(this).val());
    });

    if($('#wallet-icon-select').length) {
        initial = `bi-${$("#wallet-icon-select option:selected").text()}`

        $("#wallet-icon-select").children().each(function ()
        {
            let text = this.innerHTML;

            this.innerHTML = `<span icon='bi bi-${text}'></span>${text}`

        });

        let v = $(".wallet-icon .bi");
        v.removeClass("bi-wallet");
        v.addClass(initial);

        $("#wallet-icon-select").change(() => {
            v.removeClass(initial);
            initial = `bi-${$("#wallet-icon-select option:selected").text()}`
            v.addClass(initial);
        });
    }
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
            e.stopPropagation();
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

function setUpQuickLink() {
    let origin = "#quick_link_origin_id";
    let destination = "#quick_link_destination_id";
    $('#quick_link_form').submit(function (e) {
        if ($(origin).val() == $(destination).val()) {
            $('#destination_same').show();
            $(destination).addClass('form-fail');
            e.stopPropagation();
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

function setUpHome() {
    window.onscroll = () => {
        let botScreen = window.innerHeight + window.scrollY;
        if (botScreen - (1 * window.innerHeight / 5) > $("#balance").position().top) {
            if (botScreen - (1 * window.innerHeight / 5) > $("#balance").position().top + $("#balance").height()) {
                $("#bar").prop("style", "transform: rotate(0deg)");
                return;
            }

            //  25deg -> at the div top of the bar
            //  0deg -> bo

            let rot = 25 * Math.max((1 - (((botScreen - (1 * window.innerHeight / 5)) - $("#balance").position().top) / $("#balance").height() * 1.2)), 0);
            $("#bar").prop("style", `transform: rotate(${-rot}deg)`);
        }
    };
}

// This function will change the path of the window to the desired location
function moveTo(target) {
    //console.log(target);
    //window.location.href = target;
    //window.location.reload();
    window.location = target;
}
