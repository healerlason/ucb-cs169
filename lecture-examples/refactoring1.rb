# Goal: when customer first logs in, see if they recently opted out of email.
#  If yes, show a nice message encouraging them to opt back in.
#  self.current_user returns the current user object.

# version 1

# in CustomersController

def welcome
  if self.current_user.e_blacklist?  &&
      self.current_user.valid_email_address?  &&
      !(m = Option.value(:encourage_email_opt_in)).blank?
    m << '.' unless m =~ /[.!?:;,]$/
    m << ' Click the Billing Address tab (above) to update your preferences.'
    flash[:notice] ||= m
  end
end

# Problems:
#  - what we really want is once per login - this doesn't do that
#  - exposes implementation details of how we compute whether customer
#       needs to see this message (ie of what "opted out of email" means)
#  - mixes levels of abstraction
#  - how do we know what flash[:notice] was coming in?  if it was non-nil,
#       this will never do anything - yet now requires us to know this


#  version 3

# in ApplicationController

def login_message
  encourage_opt_in_message if self.current_user.has_opted_out_of_email? 
end
#
# ....
#
def encourage_opt_in_message
  if !(m = Option.value(:encourage_email_opt_in)).blank?
    m << '.' unless m =~ /[.!?:;,]$/
    m << ' Click the Billing Address tab (above) to update your preferences.'
    m
  else nil
  end
end


# in customer.rb

def has_opted_out_of_email?
  e_blacklist? && valid_email_address?
end

# in SessionsController#create

flash[:notice] = login_message || "Logged in successfully"


# in application_controller.rb

