require 'spec_helper'
require 'uber'

describe Uber::API::Reminders do
  let!(:client) { setup_client }

  describe "get reminder" do
    before do
      # From: https://developer.uber.com/docs/rides/api/v1-reminders-get
      stub_uber_request(:get, 'v1/reminders/48ee034e-311d-41ea-9794-02fc8dcd8696',
                        {"reminder_status"=>"pending", "reminder_id"=>"48ee034e-311d-41ea-9794-02fc8dcd8696", "reminder_time"=>1473296851,
                         "event"=>{"latitude"=>nil, "time"=>1473507651, "name"=>nil, "longitude"=>nil, "location"=>nil}, "product_id"=>{}}
      )
    end

    it "should return details about reminder" do
      reminder = client.reminder('48ee034e-311d-41ea-9794-02fc8dcd8696')
      expect(reminder).to be_instance_of Uber::Reminder
      expect(reminder.event).to be_instance_of Uber::Reminder::Event
      expect(reminder.reminder_id).to eq "48ee034e-311d-41ea-9794-02fc8dcd8696"
    end

    it "should also respond to reminder_detail" do
      reminder = client.reminder_detail('48ee034e-311d-41ea-9794-02fc8dcd8696')
      expect(reminder).to be_instance_of Uber::Reminder
      expect(reminder.event).to be_instance_of Uber::Reminder::Event
      expect(reminder.reminder_id).to eq "48ee034e-311d-41ea-9794-02fc8dcd8696"
    end
  end

  describe "add reminder" do
    before do
      # From: https://developer.uber.com/docs/rides/api/v1-reminders-post
      @time_now = Time.at(1473275408)
      stub_uber_request(:post, 'v1/reminders',
                        {
                            reminder_time: 1473357203,
                            phone_number: '+91-9999999999',
                            event: {time: 1473509642},
                            trip_branding: {link_text: 'My first reminder'},
                            reminder_id: 'rem1'
                        },
                        :body => {
                            reminder_time: 1473357203,
                            phone_number: '+91-9999999999',
                            event: {time: 1473509642},
                            trip_branding: {link_text: 'My first reminder'},
                            reminder_id: 'rem1'
                        })
    end
    it 'should return reminder with details' do
      allow(Time).to receive(:now).and_return(@time_now)
      reminder = client.add_reminder({reminder_time: Time.local(2016, 9, 8, 23, 23, 23),
                                      phone_number: '+91-9999999999',
                                      trip_branding: {link_text: 'My first reminder'},
                                      event: {time: Time.now + 234234},
                                      reminder_id: 'rem1' })
      expect(reminder).to be_instance_of Uber::Reminder
      expect(reminder.event).to be_instance_of Uber::Reminder::Event
      expect(reminder.trip_branding).to be_instance_of Uber::Reminder::TripBranding
      expect(reminder.reminder_time).to eq Time.local(2016, 9, 8, 23, 23, 23)
      expect(reminder.event.time).to eq @time_now + 234234
      expect(reminder.reminder_id).to eq 'rem1'
    end
  end

  describe "update reminder" do
    before do
      # From: https://developer.uber.com/docs/rides/api/v1-reminders-patch
      @time_now = Time.at(1473275408)
      stub_uber_request(:patch, 'v1/reminders/rem1', {reminder_time: 1473530003,
                                                      phone_number: '+91-9999999999',
                                                      event: {time: 1473509642},
                                                      reminder_id: 'rem1' })
    end
    it 'should return updated reminder' do
      allow(Time).to receive(:now).and_return(@time_now)
      reminder = client.update_reminder('rem1', {reminder_time: Time.local(2016, 9, 10, 23, 23, 23),
                                                 phone_number: '+91-9999999999',
                                                 event: {time: Time.now + 234234},
                                                 reminder_id: 'rem1' })
      expect(reminder).to be_instance_of Uber::Reminder
      expect(reminder.reminder_time).to eq Time.local(2016, 9, 10, 23, 23, 23)
      expect(reminder.event.time).to eq @time_now + 234234
      expect(reminder.reminder_id).to eq 'rem1'
    end
  end

  describe "delete reminder" do
    before do
      # From: https://developer.uber.com/docs/rides/api/v1-reminders-delete
      stub_uber_request(:delete, 'v1/reminders/my_reminder', nil, {status_code: 204})
    end
    it 'should successfully delete the reminder' do
      reminder = client.delete_reminder 'my_reminder'
      expect(reminder).to be_instance_of Uber::Reminder
    end
  end
end