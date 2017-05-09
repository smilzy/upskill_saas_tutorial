/* global $, Stripe */
//Document ready
$(document).on('turbolinks:load', function(){
    var theform = $('#pro_form');
    var submitBtn = $('#form-submit-btn');
    
    //Set Stripe public key.
    Stripe.setPublishableKey( $('meta[name="stripe-key"]').attr('content') );
    
    //When user clicks form submit btn.
    submitBtn.click(function(){
        //prevent default submission behavior.
        event.preventDefault();
    

    
        //Collect the credit card fields.
        var ccNum = $('#card_number').val(); //# poprzedza ID naszych elementów.
                                            // .val(); wyszczególnia tylko wartość
        var cvcNum = $('#card_code').val(),
            expMonth = $('#card_month').val(),  // po przecinku wiele varów dodaję
            expYear = $('#card_year').val();
        //Send the card info to Stripe.
        Stripe.createToken({
            number: ccNum,
            cvc: cvcNum,
            exp_month: expMonh,
            exp_year: expYear       // ostatni el. nie ma nic na koncu
        }, stripeResponseHandler);
    });
    
    //Stripe will return a card token
    //Inject card token as hidden field into form.
    //Submit form to our Rails app.
});