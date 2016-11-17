require "tyrant/railtie"

Tyrant::Mailer.class_eval do
  def pony_options
      Pony.options = {
                      from: "admin@email.com",
                      via: :smtp, 
                      via_options: {
                                    address: "smtp.gmail.com", 
                                    port: "587",
                                    domain: 'localhost:3000', 
                                    enable_starttls_auto: true, 
                                    user_name: "emanuele.magliozzi@gmail.com", 
                                    password: "lfiwprrihduuivau", 
                                    subject: "Reset password TRB blog",
                                    authentication: :plain
                                    }
                      }
    end
end
