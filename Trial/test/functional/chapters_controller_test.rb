require 'test_helper'

class ChaptersControllerTest < ActionController::TestCase
  setup do
    @chapter = chapters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chapters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chapter" do
    assert_difference('Chapter.count') do
      post :create, chapter: { book_id: @chapter.book_id, created_on: @chapter.created_on, gchapter_id: @chapter.gchapter_id, maintenance: @chapter.maintenance, reviewed: @chapter.reviewed, story: @chapter.story, title: @chapter.title, user_id: @chapter.user_id }
    end

    assert_redirected_to chapter_path(assigns(:chapter))
  end

  test "should show chapter" do
    get :show, id: @chapter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chapter
    assert_response :success
  end

  test "should update chapter" do
    put :update, id: @chapter, chapter: { book_id: @chapter.book_id, created_on: @chapter.created_on, gchapter_id: @chapter.gchapter_id, maintenance: @chapter.maintenance, reviewed: @chapter.reviewed, story: @chapter.story, title: @chapter.title, user_id: @chapter.user_id }
    assert_redirected_to chapter_path(assigns(:chapter))
  end

  test "should destroy chapter" do
    assert_difference('Chapter.count', -1) do
      delete :destroy, id: @chapter
    end

    assert_redirected_to chapters_path
  end
end
