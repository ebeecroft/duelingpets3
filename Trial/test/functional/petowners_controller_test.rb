require 'test_helper'

class PetownersControllerTest < ActionController::TestCase
  setup do
    @petowner = petowners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:petowners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create petowner" do
    assert_difference('Petowner.count') do
      post :create, petowner: { adopted_on: @petowner.adopted_on, pet_id: @petowner.pet_id, pet_name: @petowner.pet_name, user_id: @petowner.user_id }
    end

    assert_redirected_to petowner_path(assigns(:petowner))
  end

  test "should show petowner" do
    get :show, id: @petowner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @petowner
    assert_response :success
  end

  test "should update petowner" do
    put :update, id: @petowner, petowner: { adopted_on: @petowner.adopted_on, pet_id: @petowner.pet_id, pet_name: @petowner.pet_name, user_id: @petowner.user_id }
    assert_redirected_to petowner_path(assigns(:petowner))
  end

  test "should destroy petowner" do
    assert_difference('Petowner.count', -1) do
      delete :destroy, id: @petowner
    end

    assert_redirected_to petowners_path
  end
end
