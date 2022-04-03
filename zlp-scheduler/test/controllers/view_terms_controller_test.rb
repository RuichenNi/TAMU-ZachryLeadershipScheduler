require 'test_helper'

class ViewTermsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get view_terms_index_url
    assert_response :success
  end

end
