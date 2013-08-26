require 'test_helper'

class SpellBooksControllerTest < ActionController::TestCase
  setup do
    @spell_book = spell_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spell_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spell_book" do
    assert_difference('SpellBook.count') do
      post :create, spell_book: { klass_id: @spell_book.klass_id, name: @spell_book.name }
    end

    assert_redirected_to spell_book_path(assigns(:spell_book))
  end

  test "should show spell_book" do
    get :show, id: @spell_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spell_book
    assert_response :success
  end

  test "should update spell_book" do
    put :update, id: @spell_book, spell_book: { name: @spell_book.name }
    assert_redirected_to library_path(@spell_book.library)
  end

  test "should destroy spell_book" do
    assert_difference('SpellBook.count', -1) do
      delete :destroy, id: @spell_book
    end

    assert_redirected_to spell_books_path
  end
end
