require 'test_helper'

class PmsControllerTest < ActionController::TestCase
  setup do
    @pm = pms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pm" do
    assert_difference('Pm.count') do
      post :create, pm: { created_on: @pm.created_on, description: @pm.description, from_user_id: @pm.from_user_id, maintenance: @pm.maintenance, title: @pm.title, user_id: @pm.user_id }
    end

    assert_redirected_to pm_path(assigns(:pm))
  end

  test "should show pm" do
    get :show, id: @pm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pm
    assert_response :success
  end

  test "should update pm" do
    put :update, id: @pm, pm: { created_on: @pm.created_on, description: @pm.description, from_user_id: @pm.from_user_id, maintenance: @pm.maintenance, title: @pm.title, user_id: @pm.user_id }
    assert_redirected_to pm_path(assigns(:pm))
  end

  test "should destroy pm" do
    assert_difference('Pm.count', -1) do
      delete :destroy, id: @pm
    end

    assert_redirected_to pms_path
  end
end
