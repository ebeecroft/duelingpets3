require 'test_helper'

class SbooksControllerTest < ActionController::TestCase
  setup do
    @sbook = sbooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sbooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sbook" do
    assert_difference('Sbook.count') do
      post :create, sbook: { created_on: @sbook.created_on, maintenance: @sbook.maintenance, name: @sbook.name, series_open: @sbook.series_open, user_id: @sbook.user_id }
    end

    assert_redirected_to sbook_path(assigns(:sbook))
  end

  test "should show sbook" do
    get :show, id: @sbook
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sbook
    assert_response :success
  end

  test "should update sbook" do
    put :update, id: @sbook, sbook: { created_on: @sbook.created_on, maintenance: @sbook.maintenance, name: @sbook.name, series_open: @sbook.series_open, user_id: @sbook.user_id }
    assert_redirected_to sbook_path(assigns(:sbook))
  end

  test "should destroy sbook" do
    assert_difference('Sbook.count', -1) do
      delete :destroy, id: @sbook
    end

    assert_redirected_to sbooks_path
  end
end
