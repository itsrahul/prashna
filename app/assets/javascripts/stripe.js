class StripeAuthentication
{
  constructor(options)
  {
    this.$form = options.form;
    this.stripe_token = options.form.data('stripe_token');
    this.elementsDiv = options.form.find(options.elementsDiv);
    this.errorDiv = options.form.find(options.errorDiv)[0];
    this.stripe_key = this.$form.data('stripe-key');
    this.stripe = Stripe(this.stripe_key);
    // Create an instance of Elements.
    this.elements = this.stripe.elements();
    
    // Custom styling can be passed to options when creating an Element.
    // (Note that this demo uses a wider set of styles than the guide below.)
    let style = {
      base: {
        color: '#32325d',
        fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
        fontSmoothing: 'antialiased',
        fontSize: '16px', '::placeholder': { color: '#aab7c4' }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    };
    // Create an instance of the card Element.
    this.card = this.elements.create('card', {style: style});
  }

  init()
  {

    // Add an instance of the card Element into the `card-element` <div>.
    this.card.mount('#card-element');

    // Handle real-time validation errors from the card Element.
    this.card.on('change', (event) => {
      // let displayError = document.getElementById('card-errors');
      if (event.error) 
      {
        this.errorDiv.textContent = event.error.message;
      } 
      else 
      {
        this.errorDiv.textContent = '';
      }
    });
    
    // Handle form submission.
    // let form = document.getElementById('payment-form');
    this.$form[0].addEventListener('submit', (event) => {
      event.preventDefault();

      this.stripe.createToken(this.card).then( (result) => {
        // Inform the user if there was an error.
        if (result.error)
        {
          // let errorElement = document.getElementById('card-errors');
          this.errorDiv.textContent = result.error.message;
        } 
        else 
        {
          // Send the token to your server.
          this.stripeTokenHandler(result.token);
        }
      });
    });

  }

  stripeTokenHandler(token) {
    // Submit the form with the token ID.
    // Insert the token ID into the form so it gets submitted to the server
    // let form = document.getElementById('payment-form');
    let hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('id' ,  'stripe_token');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripe_token');
    hiddenInput.setAttribute('value', token.id);
    this.$form[0].append(hiddenInput);
    // Submit the form
    this.$form.submit();
  }
}


document.addEventListener('turbolinks:load', function() {
  let options = {
    form: $('#payment-form'),
    elementsDiv: '#card-element',
    errorDiv: '#card-errors',
  }
  if (options.form.length)
  {
    let payment = new StripeAuthentication(options);
    payment.init();
  }
});
