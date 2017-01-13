require 'pony'

module Notification
  class User < Trailblazer::Operation

    # contract do
    #   property :email, virtual: true
    #   property :type, virtual: true
    # end

    def model!(params)
      params[:model]
    end

    def process(params)
      email_options
      notify_user(params[:email], params[:type])
    end

  private
    def email_options
      Pony.options = {
                      from: "admin@email.com",
                      via: :smtp, 
                      via_options: {
                                    address: "smtp.gmail.com", 
                                    port: "587",
                                    domain: 'localhost:3000', 
                                    enable_starttls_auto: true, 
                                    user_name: "your_email@gmail.com", 
                                    password: "your_password", 
                                    authentication: :plain
                                    } 
                      }
    end
    
    def notify_user(email, type)
      
      subjects = {
        "welcome" => "Welcome in TRB Blog",
        "block" => "TRB Blog Notification - You have been blocked",
        "delete" => "TRB Blog Notification - Your account has been deleted",
        "change_password" => "TRB Blog Notification - Your password has been changed",
      }

      bodies = {
        "welcome" => "Hey mate, thank you for joining us....it's gonna be fun!! :)",
        "block" => "Hey bro, I'm sorry but you have said or done something wrong and you have been blocked! :(",
        "delete" => "Noooooo bro, why???? You have deleted your account! :(",
        "change_password" => "Hi, your password has been changed. In case this doesn't sound familiar contact the Blog admin ASAP!!",
      } 

      Pony.mail({ 
                  to: email,
                  subject: subjects[type],               
                  body: bodies[type],
                })
    end
  end

end