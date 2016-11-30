require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'
require "reform/form/coercion"

module User::Contract 
  class Create < Reform::Form 
    feature Reform::Form::Dry
    feature Reform::Form::Coercion
    include Disposable::Twin::Property::Hash

    property :email

    property :content, field: :hash do
      property :firstname
      property :lastname
      property :gender
      property :phone
      property :age
      property :block#, type: Types::Form::Int
      
      # validation do
      #   rule(not_block: [:block]) do |block|
      #     block != true
      #   end
      # end

    end
    
    unnest :firstname, from: :content
    unnest :lastname, from: :content
    unnest :gender, from: :content
    unnest :phone, from: :content
    unnest :age, from: :content
    unnest :block, from: :content

    validation do
      configure do
        option :form
        config.messages_file = 'config/error_messages.yml'

        def unique_email?
          User.where("email = ?", form.email).size == 0
        end

        def email?(value)
          ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(value).nil?
        end
      end

      required(:email).filled(:email?, :unique_email?)
    end
  end
end