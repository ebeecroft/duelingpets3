require 'test_helper'

class PrepliesControllerTest < ActionController::TestCase
  setup do
    @preply = preplies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:preplies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create preply" do
    assert_difference('Preply.count') do
      post :create, preply: { created_on: @preply.created_on, maintenance: @preply.maintenance, message: @preply.message, pm_id: @preply.pm_id, user_id: @preply.user_id }
    end

    assert_redirected_to preply_path(assigns(:preply))
  end

  test "should show preply" do
    get :show, id: @preply
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @preply
    assert_response :success
  end

  test "should update preply" do
    put :update, id: @preply, preply: { created_on: @preply.created_on, maintenance: @preply.maintenance, message: @preply.message, pm_id: @preply.pm_id, user_id: @preply.user_id }
    assert_redirected_to preply_path(assigns(:preply))
  end

  test "should destroy preply" do
    assert_difference('Preply.count', -1) do
      delete :destroy, id: @preply
    end

    assert_redirected_to preplies_path
  end
end
