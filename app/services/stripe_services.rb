class StripeServices

  def self.makePayment(stripe_card_token, current_user, pack)

    stripe_user_token = current_user.get_or_create_stripe_token
    payment = current_user.payment_transactions.inprogress.create(pack: pack)

    options = {
      amount: pack.price.to_i*100,
      currency: 'inr',
      source: stripe_card_token,
      description: "Purchasing Pack - #{pack.name}",
    }

    stripe_customer = Stripe::Customer.retrieve(stripe_user_token)
    stripe_charge = Stripe::Charge.create(options)
    Stripe::Charge.update(stripe_charge.id, { customer: stripe_customer.id})
    
    payment.update_columns(charge_id: stripe_charge.id)     
    
    if stripe_charge.paid
      payment.success!
      payment.update_columns(success_at: payment.updated_at)
      return true
    else
      payment.failed!
      return false
    end
  end

end