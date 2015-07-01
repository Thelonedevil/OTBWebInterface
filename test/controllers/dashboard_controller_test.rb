require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get channel" do
    get :channel
    assert_response :success
  end

end
