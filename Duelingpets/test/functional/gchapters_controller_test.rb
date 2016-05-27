require 'test_helper'

class GchaptersControllerTest < ActionController::TestCase
  setup do
    @gchapter = gchapters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gchapters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gchapter" do
    assert_difference('Gchapter.count') do
      post :create, gchapter: { created_on: @gchapter.created_on, title: @gchapter.title }
    end

    assert_redirected_to gchapter_path(assigns(:gchapter))
  end

  test "should show gchapter" do
    get :show, id: @gchapter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gchapter
    assert_response :success
  end

  test "should update gchapter" do
    put :update, id: @gchapter, gchapter: { created_on: @gchapter.created_on, title: @gchapter.title }
    assert_redirected_to gchapter_path(assigns(:gchapter))
  end

  test "should destroy gchapter" do
    assert_difference('Gchapter.count', -1) do
      delete :destroy, id: @gchapter
    end

    assert_redirected_to gchapters_path
  end
end
