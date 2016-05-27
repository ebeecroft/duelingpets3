require 'test_helper'

class TcontainersControllerTest < ActionController::TestCase
  setup do
    @tcontainer = tcontainers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tcontainers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tcontainer" do
    assert_difference('Tcontainer.count') do
      post :create, tcontainer: { forum_id: @tcontainer.forum_id, name: @tcontainer.name }
    end

    assert_redirected_to tcontainer_path(assigns(:tcontainer))
  end

  test "should show tcontainer" do
    get :show, id: @tcontainer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tcontainer
    assert_response :success
  end

  test "should update tcontainer" do
    put :update, id: @tcontainer, tcontainer: { forum_id: @tcontainer.forum_id, name: @tcontainer.name }
    assert_redirected_to tcontainer_path(assigns(:tcontainer))
  end

  test "should destroy tcontainer" do
    assert_difference('Tcontainer.count', -1) do
      delete :destroy, id: @tcontainer
    end

    assert_redirected_to tcontainers_path
  end
end
