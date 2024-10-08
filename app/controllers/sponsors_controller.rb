class SponsorsController < ApplicationController
  before_action :set_api_key
  def test_route
    test = {
        firstName: "test",
        fullName: "test",
        party: "test",
        state: "test",
        last_name: "test",
        bioguideId: "Y000064"
    }

    unless Sponsor.find_by(bioguide_id: test[:bioguideId])
      puts "not found!!"
      sponsor = fetch_bill_sponsor_information(test)
      render plain: "Sponsor info: #{sponsor}"
      return
    end

    puts "found!!"
    sponsor = Sponsor.find_by(bioguide_id: test[:bioguideId])
    render plain: "#{sponsor}"

  end

  private

  def fetch_bill_sponsor_information(bill)
    puts "this the bill", bill
    sponsor_data = {
      first_name: bill[:firstName],
      full_title: bill[:fullName],
      party: bill[:party],
      state: bill[:state],
      last_name: bill[:last_name],
      bioguide_id: bill[:bioguideId]
    }

    url = "https://api.congress.gov/v3/member/#{bill[:bioguideId]}?api_key=#{@api_key}"
    response = Faraday.get(url)
    data = JSON.parse(response.body, symbolize_names: true)

    puts data
    sponsor_data[:image_url] = data[:member][:depiction][:imageUrl]
    sponsor_data[:member_type] = data[:member][:terms].last[:memberType]

    Sponsor.create(sponsor_data)

    sponsor_data
  end
end

def set_api_key
  @api_key = Rails.application.credentials.congress_api_key
end
