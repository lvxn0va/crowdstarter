require 'spec_helper'

PUser = Hashie::Mash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {
        :email => "user@test.site",
        :name => "Test User",
        :image => "face.jpg"
      },
      :credentials => { :token => "abc123" }
    })

def signin_setup
  OmniAuth.config.mock_auth[:facebook] = PUser
  User.create(:email=>PUser.info.email,
            :facebook_uid => PUser.uid,
           )
end

describe "Sign in", :type => :request do
  it "signs in with facebook" do
    signin_setup
    visit '/'
    within("#user-nav") do
      fill_in 'email', :with => PUser.info.email
      click_button "Sign in"
    end

    within('.user-detail') do
      page.should have_content('user@test.site')
    end
  end
end