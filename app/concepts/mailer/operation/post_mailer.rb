require 'pony'

module Notification
  class Post < Trailblazer::Operation

    def model!(params)
      params[:model]
    end

    def process(params)
      email_options
      notify_user(params[:post], params[:type]) unless ::User.where('id like ?', params[:post].user_id).size != 1
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
    
    def notify_user(post, type)
      
      subjects = {
        "create" => "TRB Blog Notification - #{post.title} has been published",
        "delete" => "TRB Blog Notification - #{post.title} has been deleted",
      }

      bodies = {
        "create" => "Congratulation, your post has been published successfully. Thank you!",
        "delete" => "#{post.title} has been delete.",
      } 

      email = ::User.find(post.user_id).email

      Pony.mail({ 
                  to: email,
                  subject: subjects[type],               
                  body: bodies[type],
                })
    end
  end

end