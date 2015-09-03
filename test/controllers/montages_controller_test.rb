require 'test_helper'

class MontagesControllerTest < ActionController::TestCase
  setup do
    @montage = montages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:montages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create montage" do
    assert_difference('Montage.count') do
      post :create, montage: { string: @montage.string }
    end

    assert_redirected_to montage_path(assigns(:montage))
  end

  test "should show montage" do
    get :show, id: @montage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @montage
    assert_response :success
  end

  test "should update montage" do
    patch :update, id: @montage, montage: { string: @montage.string }
    assert_redirected_to montage_path(assigns(:montage))
  end

  test "should destroy montage" do
    assert_difference('Montage.count', -1) do
      delete :destroy, id: @montage
    end

    assert_redirected_to montages_path
  end
end
