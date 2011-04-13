require 'test_helper'

class SolutionsControllerTest < ActionController::TestCase
  setup do
    @solution = solutions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:solutions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create solution" do
    assert_difference('Solution.count') do
      post :create, :solution => @solution.attributes
    end

    assert_redirected_to solution_path(assigns(:solution))
  end

  test "should show solution" do
    get :show, :id => @solution.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @solution.to_param
    assert_response :success
  end

  test "should update solution" do
    put :update, :id => @solution.to_param, :solution => @solution.attributes
    assert_redirected_to solution_path(assigns(:solution))
  end

  test "should destroy solution" do
    assert_difference('Solution.count', -1) do
      delete :destroy, :id => @solution.to_param
    end

    assert_redirected_to solutions_path
  end
end
