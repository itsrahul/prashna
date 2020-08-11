class StripeServices

  def self.makePayment(stripe_user_token, options)
    stripe_customer = Stripe::Customer.retrieve(stripe_user_token)
    stripe_charge = Stripe::Charge.create(options)
    Stripe::Charge.update(stripe_charge.id, { customer: stripe_customer.id})
    
    return stripe_charge
  end

end