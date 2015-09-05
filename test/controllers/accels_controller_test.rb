require 'test_helper'

class AccelsControllerTest < ActionController::TestCase
  setup do
    @accel = accels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accel" do
    assert_difference('Accel.count') do
      post :create, accel: { accelx: @accel.accelx, accely: @accel.accely, accelz: @accel.accelz, rota: @accel.rota, rotb: @accel.rotb, rotg: @accel.rotg }
    end

    assert_redirected_to accel_path(assigns(:accel))
  end

  test "should show accel" do
    get :show, id: @accel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @accel
    assert_response :success
  end

  test "should update accel" do
    patch :update, id: @accel, accel: { accelx: @accel.accelx, accely: @accel.accely, accelz: @accel.accelz, rota: @accel.rota, rotb: @accel.rotb, rotg: @accel.rotg }
    assert_redirected_to accel_path(assigns(:accel))
  end

  test "should destroy accel" do
    assert_difference('Accel.count', -1) do
      delete :destroy, id: @accel
    end

    assert_redirected_to accels_path
  end
end
