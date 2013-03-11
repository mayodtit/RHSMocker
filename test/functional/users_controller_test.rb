require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { first_name: 'Jimbob', install_id: '134567', last_name: 'ClappCreate' }
    end
    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { birth_date: @user.birth_date, first_name: @user.first_name, install_id: @user.install_id, last_name:'Update Test'}
    assert_redirected_to user_path
  end

#  test "should destroy user" do
#    assert_difference('User.count', -1) do
#      delete :destroy, id: @user
#    end
#    assert_redirected_to users_path
#  end
  
  test "should add location to user" do
    put :addLocation, id: @user, lat:'11.7894', long:'10.23456'
    assert_redirected_to user_path
  end

end
