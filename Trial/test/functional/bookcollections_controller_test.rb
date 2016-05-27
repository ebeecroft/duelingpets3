require 'test_helper'

class BookcollectionsControllerTest < ActionController::TestCase
  setup do
    @bookcollection = bookcollections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bookcollections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bookcollection" do
    assert_difference('Bookcollection.count') do
      post :create, bookcollection: { created_on: @bookcollection.created_on, maintenance: @bookcollection.maintenance, series_open: @bookcollection.series_open, title: @bookcollection.title, user_id: @bookcollection.user_id }
    end

    assert_redirected_to bookcollection_path(assigns(:bookcollection))
  end

  test "should show bookcollection" do
    get :show, id: @bookcollection
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bookcollection
    assert_response :success
  end

  test "should update bookcollection" do
    put :update, id: @bookcollection, bookcollection: { created_on: @bookcollection.created_on, maintenance: @bookcollection.maintenance, series_open: @bookcollection.series_open, title: @bookcollection.title, user_id: @bookcollection.user_id }
    assert_redirected_to bookcollection_path(assigns(:bookcollection))
  end

  test "should destroy bookcollection" do
    assert_difference('Bookcollection.count', -1) do
      delete :destroy, id: @bookcollection
    end

    assert_redirected_to bookcollections_path
  end
end
