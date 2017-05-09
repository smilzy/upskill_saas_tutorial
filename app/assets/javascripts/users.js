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
        submitBtn.val("Processing").prop('disabled', true);

    
        //Collect the credit card fields.
        var ccNum = $('#card_number').val(); //# poprzedza ID naszych elementów.
                                            // .val(); wyszczególnia tylko wartość
        var cvcNum = $('#card_code').val(),
            expMonth = $('#card_month').val(),  // po przecinku wiele varów dodaję
            expYear = $('#card_year').val();
            
        // Use Stripe JS library to check for card errors.
        var error = false;
        
        //Validate card number.
        if(!Stripe.card.validateCardNumber(ccNum)) {    //sprawdza czy ccNum poprawne i zwraca wartość TRUE albo FALSE. !=not. If not"false" = wykonaj. Jeśli not"true" = nie wykonuj.
            error = true;
            alert('The credit card number appears to be invalid.')
        }
        
        //Validate CVC number.
        if(!Stripe.card.validateCVC(cvcNum)) {    //sprawdza czy ccNum poprawne i zwraca wartość TRUE albo FALSE. !=not. If not"false" = wykonaj. Jeśli not"true" = nie wykonuj.
            error = true;
            alert('The CVC number appears to be invalid.')
        }
        
        //Validate expiration date.
        if(!Stripe.card.validateExpiry(expMonth, expYear)) {    //sprawdza czy ccNum poprawne i zwraca wartość TRUE albo FALSE. !=not. If not"false" = wykonaj. Jeśli not"true" = nie wykonuj.
            error = true;
            alert('The expiration date appears to be invalid.')
        }
        
        if (error) {
            //If there are card errors, don't send to Stripe.
            submitBtn.prop('disabled', false).val("Sign Up");
        } else {
            //Send the card info to Stripe.
            Stripe.createToken({
                number: ccNum,
                cvc: cvcNum,
                exp_month: expMonh,
                exp_year: expYear       // ostatni el. nie ma nic na koncu.
            }, stripeResponseHandler);
        }
        return false;   // Dodawane w jscript, aby usprawnić 'wyjście' z funkcji
    });
    
    //Stripe will return a card token.
    function stripeResponseHandler(status, response) {
        //Get the token from the response.
        var token = response.id;
        
        //Inject card token as hidden field into form.
        theForm.append( $('<input type="hidden" name="user[stripe_card_token]">').val(token) );
        
        //Submit form to our Rails app.
        theForm.get(0).submit();
    }
});