require 'test_helper'

class ChangesInputControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get changes_input_index_url
    assert_response :success
  end

end
