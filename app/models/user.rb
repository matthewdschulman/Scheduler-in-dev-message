# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  #obviously move these
  CLIENT_ID='541377a9a621710000ff3621'
  SECRET='fkFfK2SBmrsjFipWzFLFzu'

  ACCESS_TOKEN_VENMO='ckMjcrx9ydVyMVTGUN5MnQmgvp6VRvZk'


  def parsePlaidForUser(access_token)
    date = (Date.yesterday).to_s
    gteString = "\{\"gte\":\"#{date}\"\}"
    str = URI.encode("https://tartan.plaid.com/connect?client_id=#{CLIENT_ID}&secret=#{SECRET}&access_token=#{access_token}&options=#{gteString}")
    @response = RestClient.get str
    transactions = JSON.parse(@response)["transactions"]
    sum = 0.0
    notes = Hash.new 0.0
    for t in transactions
      if t["amount"].to_s.split(".").length > 1 && t["amount"].to_i > 0
        cents = (t["amount"].to_i + 1 - t["amount"]).round(2)
        sum += cents
        if t["category"] == nil
          notes["Misc"] ? notes["Misc"]+= cents : notes["Misc"]= 0
        elsif t["category"].include? "Arts and Entertainment"
          notes["🎨"] ? notes["🎨"]+= cents : notes["🎨"]= 0
        elsif t["category"].include? "Bank Fees"
          notes["💳"] ? notes["💳"]+= cents : notes["💳"]= 0
        elsif t["category"].include? "Community"
          notes["🏡"] ? notes["🏡"]+= cents : notes["🏡"]= 0
        elsif t["category"].include? "Food and Drink"
          notes["🍕"] ? notes["🍕"]+= cents : notes["🍕"]= 0
        elsif t["category"].include? "Parks and Outdoors"
          notes["⛺️"] ? notes["⛺️"]+= cents : notes["⛺️"]= 0
        elsif t["category"].include? "Professional"
          notes["💉"] ? notes["💉"]+= cents : notes["💉"]= 0
        elsif t["category"].include? "Service"
          notes["🔧"] ? notes["🔧"]+= cents : notes["🔧"]= 0
        elsif t["category"].include? "Shops"
          notes["🎁"] ? notes["🎁"]+= cents : notes["🎁"]= 0
        elsif t["category"].include? "Transfer"
          notes["🔃"] ? notes["🔃"]+= cents : notes["🔃"]= 0
        elsif t["category"].include? "Travel"
          notes["✈️"] ? notes["✈️"]+= cents : notes["✈️"]= 0
        else
          notes["Misc"] ? notes["Misc"]+= cents : notes["Misc"]= 0
        end
      end
    end
    return sum, notes
  end

  def chargeUser(amount, note)
    url = 'https://api.venmo.com/v1/payments'
    noteFormat = ""
    note.each do |key, val|
      noteFormat += key + " - " + "$" + val.to_s + "\r\n"
    end
    @response = RestClient.post url, :access_token => ACCESS_TOKEN_VENMO, :phone => phone_number, :note => noteFormat, :amount => -amount
    return @response
  end


  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
