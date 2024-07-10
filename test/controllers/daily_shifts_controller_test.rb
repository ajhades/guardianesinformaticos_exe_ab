require "test_helper"

class DailyShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get daily_shifts_index_url
    assert_response :success
  end

  test "should get create" do
    get daily_shifts_create_url
    assert_response :success
  end

  test "should get new" do
    get daily_shifts_new_url
    assert_response :success
  end

  test "should get destroy" do
    get daily_shifts_destroy_url
    assert_response :success
  end

  test "should get show" do
    get daily_shifts_show_url
    assert_response :success
  end
end
