require 'test_helper'

class ChangesViewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get changes_view_index_url
    assert_response :success
  end

end
