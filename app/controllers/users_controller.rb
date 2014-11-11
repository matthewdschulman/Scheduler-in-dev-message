class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  BASE_URL = 'https://tartan.plaid.com/'

  #obviously move these
  CLIENT_ID='541377a9a621710000ff3621'
  SECRET='fkFfK2SBmrsjFipWzFLFzu'

  #get rid of this var once jeff finishes his MFA stuff
  SAMPLE_JSON_RESPONSE_STR = '{
  "accounts": [
    {
      "_id": "54146a3a52575ff861e1e800",
      "_item": "5414695162f3e9565f712d48",
      "_user": "5414695062f3e9565f712d47",
      "balance": {
        "available": 8359.35,
        "current": 8359.35
      },
      "institution_type": "bofa",
      "meta": {
        "official_name": "BofA Core Checking",
        "number": "2150",
        "name": "BofA Core Checking - 2150",
        "limit": null
      },
      "type": "depository"
    },
    {
      "_id": "54146a3a52575ff861e1e801",
      "_item": "5414695162f3e9565f712d48",
      "_user": "5414695062f3e9565f712d47",
      "balance": {
        "available": 254.14,
        "current": 254.14
      },
      "institution_type": "bofa",
      "meta": {
        "official_name": "BankAmericard Cash Rewards Platinum Plus Visa",
        "number": "0479",
        "name": "BankAmericard Cash Rewards Platinum Plus Visa - 0479",
        "limit": 3000
      },
      "type": "credit"
    }
  ],
  "transactions": [
    {
      "_account": "54146a3a52575ff861e1e800",
      "_entity": "54146a3a52575ff861e1e802",
      "_id": "54146a3d52575ff861e1e86b",
      "amount": 7,
      "date": "2014-09-12",
      "name": "Venmo Des:payment Id:xxxxx792 Indn:jeffrey Kiske Id:xxxxx81992 Ccd",
      "meta": {
        "location": {
          "state": "CO"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Payment"
      ],
      "category_id": "53742c114fd7f2f065000001"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e827",
      "_id": "54146a3e52575ff861e1e88f",
      "amount": 44.81,
      "date": "2014-09-10",
      "name": "Safeway Store 00027193",
      "meta": {
        "location": {
          "state": "CA",
          "city": "Menlo Park"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Shops",
        "Supermarkets and Groceries"
      ],
      "category_id": "52544965f71e87d0070001b1"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e829",
      "_id": "54146a3e52575ff861e1e88a",
      "amount": 73.51,
      "date": "2014-09-10",
      "name": "Emelinas",
      "meta": {
        "location": {
          "state": "CA",
          "city": "San Carlos"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Food and Drink",
        "Restaurants"
      ],
      "category_id": "52544965f71e87d00700004c"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e828",
      "_id": "54146a3e52575ff861e1e88d",
      "amount": 20,
      "date": "2014-09-09",
      "name": "Heroku",
      "meta": {
        "location": {
          "state": "CA"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Professional",
        "Computers"
      ],
      "category_id": "52544965f71e87d0070000d5"
    },
    {
      "_account": "54146a3a52575ff861e1e800",
      "_entity": "54146a3a52575ff861e1e803",
      "_id": "54146a3e52575ff861e1e86f",
      "amount": -196.54,
      "date": "2014-09-09",
      "name": "Venmo Des:cashout Id:xxxxx999 Indn:jeffrey Kiske Id:xxxxx81992 Ccd",
      "meta": {
        "location": {
          "state": "CO"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer",
        "Deposit"
      ],
      "category_id": "5374271970d8a0ac6500000a"
    },
    {
      "_account": "54146a3a52575ff861e1e800",
      "_entity": "54146a3a52575ff861e1e804",
      "_id": "54146a3f52575ff861e1e898",
      "amount": 255.38,
      "date": "2014-09-08",
      "name": "Online Banking Payment to Crd 0479 Confirmation#",
      "meta": {
        "location": {}
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer"
      ],
      "category_id": "5374271470d8a0ac65000009"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e82d",
      "_id": "54146a3f52575ff861e1e890",
      "amount": 13.81,
      "date": "2014-09-08",
      "name": "Coupa Cafe Y2 E2",
      "meta": {
        "location": {
          "state": "CA",
          "city": "Stanford"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Food and Drink",
        "Restaurants",
        "Fast Food"
      ],
      "category_id": "52544965f71e87d007000068"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e82c",
      "_id": "54146a3e52575ff861e1e880",
      "amount": 11.75,
      "date": "2014-09-08",
      "name": "Chipotle 1617",
      "meta": {
        "location": {
          "state": "CA",
          "city": "Palo Alto"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Food and Drink",
        "Restaurants",
        "Fast Food"
      ],
      "category_id": "52544965f71e87d007000068"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e831",
      "_id": "54146a3f52575ff861e1e897",
      "amount": 11.75,
      "date": "2014-09-07",
      "name": "Chipotle 1617",
      "meta": {
        "location": {
          "state": "CA",
          "city": "Palo Alto"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Food and Drink",
        "Restaurants",
        "Fast Food"
      ],
      "category_id": "52544965f71e87d007000068"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e830",
      "_id": "54146a3e52575ff861e1e88e",
      "amount": -255.38,
      "date": "2014-09-07",
      "name": "Online Payment from Ch",
      "meta": {
        "location": {}
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      }
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e82a",
      "_id": "54146a3e52575ff861e1e88c",
      "amount": 7.32,
      "date": "2014-09-07",
      "name": "Uber Technologies Inc",
      "meta": {
        "location": {
          "state": "CA"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Travel",
        "Taxi and Car Services"
      ],
      "category_id": "52544965f71e87d0070001cd"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e82e",
      "_id": "54146a3e52575ff861e1e887",
      "amount": 14.08,
      "date": "2014-09-07",
      "name": "Orens Hummus Shop",
      "meta": {
        "location": {
          "state": "CA",
          "city": "Palo Alto"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Food and Drink",
        "Restaurants"
      ],
      "category_id": "52544965f71e87d00700004c"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e82f",
      "_id": "54146a3e52575ff861e1e87c",
      "amount": 34.86,
      "date": "2014-09-07",
      "name": "Campanille 32578114",
      "meta": {
        "location": {
          "state": "CA",
          "city": "Los Angeles"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Food and Drink",
        "Restaurants"
      ],
      "category_id": "52544965f71e87d00700004c"
    },
    {
      "_account": "54146a3a52575ff861e1e801",
      "_entity": "54146a3b52575ff861e1e82b",
      "_id": "54146a3e52575ff861e1e87a",
      "amount": 52.25,
      "date": "2014-09-07",
      "name": "Cvs Pharmacy",
      "meta": {
        "location": {
          "state": "CA",
          "city": "Palo Alto"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Shops",
        "Pharmacies"
      ],
      "category_id": "52544965f71e87d0070001ac"
    }
  ],
  "access_token": "WyI1NDEzNzdhOWE2MjE3MTAwMDBmZjM2MjEiLCI1NDE0Njk1MDYyZjNlOTU2NWY3MTJkNDciLCI1NDE0Njk1MTYyZjNlOTU2NWY3MTJkNDgiXQ=="
}'

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])    
    @user.update_attribute(:most_recent_plaid_sync, update_user_plaid_json(@user.access_token))
    @transactions_hash = transactions_hash
    @user.update_attribute(:users_transaction_hash, @transactions_hash.to_s)
    gon.transactions_hash = @transactions_hash
    @all_time_cents_count = get_all_time_cents_count
    @cur_user_cents_count = one_user_cents_count(@user)
    @cur_user_this_week_cents_count = one_user_cents_count_this_week(@user)
  end

  def transactions_hash
    json_data = JSON.parse(@user.most_recent_plaid_sync)
    transactions_hash = Hash.new
    json_data["transactions"].each do |transaction|
      if transaction["amount"] > 0

        amount = transaction["amount"].to_s
        if transaction["amount"].to_s.index(".") == nil
          amount = "#{amount}.00"
        elsif (transaction["amount"].to_s.size - transaction["amount"].to_s.index(".") - 1) == 1
          amount = "#{amount}0"
        end

        cents = (eval(amount).to_i + 1 - eval(amount)).round(2)

        if cents == 1.0
          cents = "0.00"
        elsif (cents.to_s.size - cents.to_s.index(".") - 1) == 1
          cents = "#{cents}0"
        end

        curTime = Time.now

        cur_hash = {:name => transaction["name"], :amount => amount, :roundup => cents} 
        if transactions_hash[transaction["date"]].nil?
          transactions_hash[transaction["date"]] = []
          transactions_hash[transaction["date"]] << cur_hash
        else 
          transactions_hash[transaction["date"]] << cur_hash
        end
      end
    end
    transactions_hash
  end

  def new
    puts "in new..."
  	@user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def create
    @user = User.new(email:params[:email],
                     password:params[:password],
                     password_confirmation:params[:password_confirmation],
                     phone_number:params[:phone_number],
                     access_token:params[:access_token])
    access_token = params[:access_token]
    str = URI.encode("https://tartan.plaid.com/connect?client_id=#{CLIENT_ID}&secret=#{SECRET}&access_token=#{access_token}")
    @response = RestClient.get str
    @user.most_recent_plaid_sync = @response
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to GoodCents!"
      redirect_to @user
    else
      redirect_to root_url, :flash => { :error => 'Error Signing In, Please Try Again'}
    end
  end

  def add_user
    type = params[:type]
    username = params[:username]
    password = params[:password]
    email = params[:email]
    post('/connect', type, username, password, email)
    if @response.code == 201 #mfa
      mfaType = JSON.parse(@response)["type"]
      if mfaType == "questions"
        obj = {}
        obj["code"] = 201
        obj["type"] = "questions"
        obj["question"] = JSON.parse(@response)["mfa"][0]["question"]
        obj["access_token"] = JSON.parse(@response)["access_token"]
        render json: obj
      end
    elsif @response.code == 200 #we're good
      obj = {}
      obj["code"] = 200
      obj["access_token"] = JSON.parse(@response)["access_token"]
      render json: obj
    else #diagnose the error
      obj = {}
      obj["code"] = @response.code
      obj["message"] = JSON.parse(@response)["message"]
      obj["resolve"] = JSON.parse(@response)["resolve"]
      render json: obj
    end
  end

  def mfa_step
    mfa = params[:mfa]
    access_token = params[:access_token]
    url = BASE_URL + 'connect/step'
    @response = RestClient.post url, :client_id => CLIENT_ID, :secret => SECRET, :mfa => mfa, :access_token => access_token
    if @response.code == 201 #mfa
      mfaType = JSON.parse(@response)["type"]
      if mfaType == "questions"
        obj = {}
        obj["code"] = 201
        obj["type"] = "questions"
        obj["question"] = JSON.parse(@response)["mfa"][0]["question"]
        obj["access_token"] = JSON.parse(@response)["access_token"]
        render json: obj
      end
    elsif @response.code == 200 #we're good
      obj = {}
      obj["code"] = 200
      obj["access_token"] = JSON.parse(@response)["access_token"]
      render json: obj
    else #diagnose the error
      obj = {}
      obj["code"] = @response.code
      obj["message"] = JSON.parse(@response)["message"]
      obj["resolve"] = JSON.parse(@response)["resolve"]
      render json: obj
    end
  end

  def post(path, type, username, password, email)
    url = BASE_URL + path
    @response = RestClient.post url, :client_id => CLIENT_ID, :secret => SECRET, :type => type, :credentials => {:username => username, :password => password} ,:email => email
    return @response
  end

  def update_user_plaid_json(access_token)
    str = URI.encode("https://tartan.plaid.com/connect?client_id=#{CLIENT_ID}&secret=#{SECRET}&access_token=#{access_token}")
    @response = RestClient.get str
    return @response
    #uncomment the above lines, and delete the below line once mfa is done
  end

  def get_all_time_cents_count
    count = 0.0
    User.all.each do |user|
      eval(user.users_transaction_hash).each do |transaction|
        transaction[1].each do |trans|
          if trans[:roundup] != "0.00"
            count = count + trans[:roundup].to_f
          end
        end
      end
    end
    count = count * 100
    count = count.to_i
    count
  end

  def one_user_cents_count(user)
    count = 0.0
    eval(user.users_transaction_hash).each do |transaction|
      transaction[1].each do |trans|
        if trans[:roundup] != "0.00"
          count = count + trans[:roundup].to_f
        end
      end
    end
    count = count * 100
    count = count.to_i
    count
  end

  def one_user_cents_count_this_week(user)
    count = 0.0
    
    eval(user.users_transaction_hash).each do |transaction|
      if transaction_in_past_week(transaction)
        transaction[1].each do |trans|
          if trans[:roundup] != "0.00"
            count = count + trans[:roundup].to_f
          end
        end
      end
    end
    count = count * 100
    count = count.to_i
    count
  end

  def transaction_in_past_week(transaction)
    
    time = Time.now.to_s
    today = DateTime.parse(time).strftime("%Y-%m-%d")
    if transaction[0] == today
      return true
    end

    time = 1.day.ago.to_s
    
    today = DateTime.parse(time).strftime("%Y-%m-%d")
    if transaction[0] == today
      return true
    end

    time = 2.days.ago.to_s
    
    today = DateTime.parse(time).strftime("%Y-%m-%d")
    if transaction[0] == today
      return true
    end

    time = 3.days.ago.to_s
    
    today = DateTime.parse(time).strftime("%Y-%m-%d")
    if transaction[0] == today
      return true
    end

    time = 4.days.ago.to_s
    today = DateTime.parse(time).strftime("%Y-%m-%d")
    if transaction[0] == today
      return true
    end

    time = 5.days.ago.to_s
    today = DateTime.parse(time).strftime("%Y-%m-%d")
    if transaction[0] == today
      return true
    end

    time = 6.days.ago.to_s
    today = DateTime.parse(time).strftime("%Y-%m-%d")
    if transaction[0] == today
      return true
    end

    return false
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
end
