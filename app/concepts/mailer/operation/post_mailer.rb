require 'pony'

module Notification
  class Post < Trailblazer::Operation
    step :model!
    step :user_exist!
    step :email_options!
    step :notify_user!

    def model!(options, post:, **)
      options["model"] = post
    end

    #if user doesn't exist no email notification
    def user_exist!(options, model:, **)
      options["result.validate"] = (::User.where("id like ?", model.user_id).size == 1)
    end

    def email_options!(options, via: :test, **)
      Pony.options = {
                      from: "admin@email.com",
                      via: via, 
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

    def notify_user!(options, model:, type:, **)
      subjects = {
        "create" => "TRB Blog Notification - #{model.title} has been created",
        "delete" => "TRB Blog Notification - #{model.title} has been deleted",
      }

      bodies = {
        "create" => "Congratulation, your post has been created successfully. Now the Administrator will assess it and decide to publish it or not.
                    You will receive an email with some feedback. Thank you!",
        "delete" => "#{model.title} has been delete.",
      } 

      email = ::User.find(model.user_id).email

      Pony.mail({ 
                  to: email,
                  subject: subjects[type],               
                  body: bodies[type],
                })
    end
  end
end