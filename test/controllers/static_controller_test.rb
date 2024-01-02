require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_home_url
    assert_response :success
  end

  test "should get about_us" do
    get static_about_us_url
    assert_response :success
  end

  test "should get terms" do
    get static_terms_url
    assert_response :success
  end
end
