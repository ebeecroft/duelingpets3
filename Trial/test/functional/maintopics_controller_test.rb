require 'test_helper'

class MaintopicsControllerTest < ActionController::TestCase
  setup do
    @maintopic = maintopics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintopics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintopic" do
    assert_difference('Maintopic.count') do
      post :create, maintopic: { description: @maintopic.description, topicname: @maintopic.topicname, user_id: @maintopic.user_id }
    end

    assert_redirected_to maintopic_path(assigns(:maintopic))
  end

  test "should show maintopic" do
    get :show, id: @maintopic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintopic
    assert_response :success
  end

  test "should update maintopic" do
    put :update, id: @maintopic, maintopic: { description: @maintopic.description, topicname: @maintopic.topicname, user_id: @maintopic.user_id }
    assert_redirected_to maintopic_path(assigns(:maintopic))
  end

  test "should destroy maintopic" do
    assert_difference('Maintopic.count', -1) do
      delete :destroy, id: @maintopic
    end

    assert_redirected_to maintopics_path
  end
end
