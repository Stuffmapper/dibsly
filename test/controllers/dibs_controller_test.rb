require 'test_helper'

class DibsControllerTest < ActionController::TestCase
  setup do
    @dib = dibs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dibs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dib" do
    assert_difference('Dib.count') do
      post :create, dib: { creator_id: @dib.creator_id, ip: @dib.ip, post_id: @dib.post_id, status: @dib.status, valid_until: @dib.valid_until }
    end

    assert_redirected_to dib_path(assigns(:dib))
  end

  test "should show dib" do
    get :show, id: @dib
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dib
    assert_response :success
  end

  test "should update dib" do
    patch :update, id: @dib, dib: { creator_id: @dib.creator_id, ip: @dib.ip, post_id: @dib.post_id, status: @dib.status, valid_until: @dib.valid_until }
    assert_redirected_to dib_path(assigns(:dib))
  end

  test "should destroy dib" do
    assert_difference('Dib.count', -1) do
      delete :destroy, id: @dib
    end

    assert_redirected_to dibs_path
  end
end
