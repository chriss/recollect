(function($) {

Recollect.Feedback = function (opts) {
    $.extend(this, this._defaults, opts);
}

Recollect.Feedback.prototype = {
    _defaults: {
    },

    show: function() {
        var self = this;
        $('body').append(Jemplate.process('feedback_tab'));
        $('#feedbackTab').click(function() {
            self.showDialog();
            return false;
        });
    },

    showDialog: function() {
        var self = this;
        $('body').append(Jemplate.process('feedback_dialog'));
        $("#feedbackForm").dialog({
            title: 'Email us',
            width: 350,
            modal: true
        });
        $('#feedbackForm .submit').click(function() {
            $('#feedbackForm').submit();
            return false;
        });
        $('#feedbackForm').validate({
            rules: {
                question: {
                    required: true,
                    minlength: 1
                },
                email: {
                    email: true,
                    required: true
                }
            },
            messages: {
                email: 'Please enter a valid email',
                question: 'Please enter a question'
            },
            submitHandler: function() {
                self.sendFeedback();
            }
        });

        self.showCaptcha();
    },

    showCaptcha: function() {
        Recaptcha.create(
            "6LdeYMYSAAAAALyIbcwQRRpkvIsVk_Q2Ku_doKYx", "feedbackCaptcha", {
                theme: "red"
            }
        );
    },

    sendFeedback: function() {
        var self = this;
        $.ajax({
            type: 'POST',
            url: '/api/feedback',
            contentType: 'json',
            data: JSON.stringify({
                email: $('#feedbackEmail').val(),
                question: $('#feedbackQuestion').val(),
                challenge: Recaptcha.get_challenge(),
                response: Recaptcha.get_response(),
                fields: {
                    'URL': String(location),
                    'Browser': $.client.browser,
                    'Browser Version': $.browser.version,
                    'Operating System': $.client.os,
                    'Window Width': $(window).width(),
                    'Window Height': $(window).height()
                }
            }),
            error: function(xhr, textStatus, errorThrown) {
                if (xhr.responseText == 'captcha-error') {
                    $('#captchaError').text(
                        'The captcha text was entered incorrectly'
                    ).show();
                }
                else {
                    $('#feedbackError').html('Sorry, but there was an error submitting your request. Please try again or send an email to <a href="mailto:support@recollect.net">support@recollect.net</a>').show();
                }
                self.showCaptcha();
            },
            success: function() {
                $("#feedbackForm").html(Jemplate.process('feedback_success'));
                $('#feedbackForm .close').click(function() {
                    $("#feedbackForm").dialog('close');
                    return false;
                });
            }
        });
        Recaptcha.destroy();
    }
};

$(function() {
    feedback = new Recollect.Feedback;
    feedback.show();
});

})(jQuery);
