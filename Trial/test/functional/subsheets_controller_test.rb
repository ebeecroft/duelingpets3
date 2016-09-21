require 'test_helper'

class SubsheetsControllerTest < ActionController::TestCase
  setup do
    @subsheet = subsheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subsheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subsheet" do
    assert_difference('Subsheet.count') do
      post :create, subsheet: { collab_mode: @subsheet.collab_mode, created_on: @subsheet.created_on, description: @subsheet.description, mainsheet_id: @subsheet.mainsheet_id, maintenance: @subsheet.maintenance, name: @subsheet.name, user_id: @subsheet.user_id }
    end

    assert_redirected_to subsheet_path(assigns(:subsheet))
  end

  test "should show subsheet" do
    get :show, id: @subsheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subsheet
    assert_response :success
  end

  test "should update subsheet" do
    put :update, id: @subsheet, subsheet: { collab_mode: @subsheet.collab_mode, created_on: @subsheet.created_on, description: @subsheet.description, mainsheet_id: @subsheet.mainsheet_id, maintenance: @subsheet.maintenance, name: @subsheet.name, user_id: @subsheet.user_id }
    assert_redirected_to subsheet_path(assigns(:subsheet))
  end

  test "should destroy subsheet" do
    assert_difference('Subsheet.count', -1) do
      delete :destroy, id: @subsheet
    end

    assert_redirected_to subsheets_path
  end
end
