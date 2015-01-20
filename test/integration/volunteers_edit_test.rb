require 'test_helper'

class VolunteersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @volunteer = volunteers(:one)
    @admin = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_volunteer_path(@volunteer)
    assert_template 'volunteers/edit'
    patch volunteer_path(@volunteer), volunteer: { first_name:  "",
                                    email: "foo@invalid" }
    assert_template 'volunteers/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_volunteer_path(@volunteer)
    assert_template 'volunteers/edit'
    first_name  = "Foo"
    last_name = "Bar"
    email = "foo@bar.com"
    patch volunteer_path(@volunteer), volunteer: { first_name:  first_name,
                                                   last_name: last_name,
                                                   email: email }
    assert_not flash.empty?
    assert_redirected_to search_volunteer_url
    @volunteer.reload
    assert_equal @volunteer.first_name,  first_name
    assert_equal @volunteer.last_name,  last_name
    assert_equal @volunteer.email, email
  end

  test "successful edit with friendly forwarding" do
    get edit_volunteer_path(@volunteer)
    log_in_as(@user)
    assert_redirected_to edit_volunteer_path(@volunteer)
    first_name  = "Foo"
    last_name = "Bar"
    email = "foo@bar.com"
    patch volunteer_path(@volunteer), volunteer: { first_name:  first_name,
                                                   last_name: last_name,
                                                   email: email }
    assert_not flash.empty?
    assert_redirected_to search_volunteer_url
    @volunteer.reload
    assert_equal @volunteer.first_name,  first_name
    assert_equal @volunteer.last_name,  last_name
    assert_equal @volunteer.email, email
  end

  test "successful delete as admin" do
    log_in_as(@admin)
    get edit_volunteer_path(@volunteer)
    assert_select 'a[href=?]', volunteer_path(@volunteer), method: :delete

    assert_difference 'Volunteer.count', -1 do
      delete volunteer_path(@volunteer)
    end

  end

  test "No delete if not admin" do
    log_in_as(@user)
    get edit_volunteer_path(@volunteer)
    assert_no_match 'a[href=?]', volunteer_path(@volunteer), method: :delete
  end


end