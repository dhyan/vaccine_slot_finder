require_relative "vaccine_slot_finder/version"
require 'httparty'
require 'byebug'

module VaccineSlotFinder
  class VaccineFinder
    include HTTParty
    base_uri 'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public'

    TEAMS_WEBHOOK = ''


    def initialize(pincode, date)
      @query_params = { query: { pincode: pincode, date: date } }
    end

    def by_pincode
      data = self.class.get("/calendarByPin", @query_params)
      parsed_data = JSON.parse(data.body)
      relevant_data = extract_relevant_data(parsed_data)
      puts 'No data found! Stay at HOME' if relevant_data.empty?
      puts relevant_data
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

    # TODO: Push to Microsoft Teams channel. Needs webhook url, where the data will be posted.
    def send_to_teams_channel(relevant_data)
      response = self.class.post(TEAMS_WEBHOOK,
                                 :body => {"text" => relevant_data.to_s}.to_json,
                                 :headers => { 'Content-Type' => 'application/json' } )
      puts response.code
    end
  end
end

# puts ARGV
# slots = VaccineSlotFinder::VaccineFinder.new(ARGV.first, ARGV.last)
# slots.by_pincode
