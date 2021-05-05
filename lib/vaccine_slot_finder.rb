require_relative "vaccine_slot_finder/version"
require 'httparty'
require 'byebug'
require 'twilio-ruby'
require 'whenever'

module VaccineSlotFinder
  class VaccineFinder
    include HTTParty
    base_uri 'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public'

    def initialize(pincode, date)
      @pincode = pincode
      @query_params = { query: { pincode: pincode, date: date } }
    end

    def by_pincode
      data = self.class.get("/calendarByPin", @query_params)
      parsed_data = JSON.parse(data.body)
      relevant_data = extract_relevant_data(parsed_data)
      puts 'No vaccines available for age group 18-45! Stay at HOME please!' if relevant_data.empty?
      puts relevant_data
      send_to_teams_channel unless relevant_data.empty?
      # send_sms_to_me unless relevant_data.empty?
    end

    def send_sms_to_me
      @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      message = @client.messages.create(
          body: "Pincode:- #{@pincode} seems to have have some vaccine slots available for you!",
          to: ENV['TWILIO_TO'],    # Replace with your phone number
          from: ENV['TWILIO_FROM'])  # Use this Magic Number for creating SMS

      puts "Message sent with message using ID:- #{message.sid} and for pincode:- #{@pincode}"
    end

    def extract_relevant_data(parsed_data)
      useful_data = []
      parsed_data['centers'].each do |row|
        vaccine_available = row['sessions'].select{ |hsh| hsh['min_age_limit'] != 45 && hsh['available_capacity'] != 0 }
        next if vaccine_available.empty?
        useful_data << '==' * 20
        useful_hash = {
            'Center Name' => row['name'],
             'Available Slots' => extract_slots(row)
        }
        useful_data << useful_hash
      end
      useful_data
    end

    def extract_slots(row)
      sessions = []
      row['sessions'].each do |session|
        useful_hash = {
            "Date" => session['date'],
            "Available Capacity" => session['available_capacity'],
            "Age limit" => session['min_age_limit'],
            "Vaccine Given" => session['vaccine'],
            "Total Slots Available" => session['slots']
        }

        sessions << useful_hash
      end
      sessions
    end

    # Push to Microsoft Teams channel. Needs webhook url, where the data will be posted.
    def send_to_teams_channel
      response = self.class.post(ENV['TEAMS_WEBHOOK'],
                                 :body => {"text" => "Pincode:- #{@pincode} has some vaccine for 18-45 age group. Try booking now!"}.to_json,
                                 :headers => { 'Content-Type' => 'application/json' } )
      puts response.code
    end
  end
end


# puts ARGV
# yml = YAML.load_file('lib/vaccine_slot_finder/bengaluru_pincodes.yaml')
# yml = yml['pincodes'].split(" ")
#
# # APi response returns availability for next 7 days
# time = Time.now.strftime('%d/%m/%Y')
# yml.each do |pin|
#   puts "Searching for pincode:- #{pin}"
#   puts VaccineSlotFinder::VaccineFinder.new(pin, time).by_pincode
#   sleep 4
# end