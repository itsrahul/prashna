require 'test_helper'

class SearchQuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get search_questions_search_url
    assert_response :success
  end

end
