require 'test_helper'

class EquipsControllerTest < ActionController::TestCase
  setup do
    @equip = equips(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:equips)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create equip" do
    assert_difference('Equip.count') do
      post :create, equip: { inventory_id: @equip.inventory_id, petowner_id: @equip.petowner_id }
    end

    assert_redirected_to equip_path(assigns(:equip))
  end

  test "should show equip" do
    get :show, id: @equip
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @equip
    assert_response :success
  end

  test "should update equip" do
    put :update, id: @equip, equip: { inventory_id: @equip.inventory_id, petowner_id: @equip.petowner_id }
    assert_redirected_to equip_path(assigns(:equip))
  end

  test "should destroy equip" do
    assert_difference('Equip.count', -1) do
      delete :destroy, id: @equip
    end

    assert_redirected_to equips_path
  end
end
