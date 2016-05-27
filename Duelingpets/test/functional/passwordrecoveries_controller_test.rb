require 'test_helper'

class PasswordrecoveriesControllerTest < ActionController::TestCase
  setup do
    @passwordrecovery = passwordrecoveries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:passwordrecoveries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create passwordrecovery" do
    assert_difference('Passwordrecovery.count') do
      post :create, passwordrecovery: { email: @passwordrecovery.email, reset_on: @passwordrecovery.reset_on, token: @passwordrecovery.token, vname: @passwordrecovery.vname }
    end

    assert_redirected_to passwordrecovery_path(assigns(:passwordrecovery))
  end

  test "should show passwordrecovery" do
    get :show, id: @passwordrecovery
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @passwordrecovery
    assert_response :success
  end

  test "should update passwordrecovery" do
    put :update, id: @passwordrecovery, passwordrecovery: { email: @passwordrecovery.email, reset_on: @passwordrecovery.reset_on, token: @passwordrecovery.token, vname: @passwordrecovery.vname }
    assert_redirected_to passwordrecovery_path(assigns(:passwordrecovery))
  end

  test "should destroy passwordrecovery" do
    assert_difference('Passwordrecovery.count', -1) do
      delete :destroy, id: @passwordrecovery
    end

    assert_redirected_to passwordrecoveries_path
  end
end
