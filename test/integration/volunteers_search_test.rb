require 'test_helper'

class VolunteersSearchTest < ActionDispatch::IntegrationTest

  def setup
    @user     = users(:one)
    @interest_category = interest_categories(:office)
    @interest_category.save
    @interest = Interest.new(name: "Typing", interest_category: @interest_category)
    @interest.save
  end

  test "Search including pagination" do
    log_in_as(@user)
    get search_volunteers_path
    assert_template 'volunteers/search'
    get volunteers_path, {last_name: "e"}
    assert_select 'div.pagination'
    first_page_of_volunteers = Volunteer.paginate(page: 1)
    first_page_of_volunteers.each do |volunteer|
      assert_select 'div[href=?]', edit_volunteer_path(volunteer)
    end
  end

  test "Find volunteers with interest" do
    log_in_as(@user)
    @volunteer = Volunteer.new(first_name: "Tim", last_name: "Smith", email: "tim@eschers.com", interests: [@interest])
    @volunteer.save
    get search_volunteers_path
    assert_template 'volunteers/search'
    get volunteers_path, {interest_ids: [@interest.id]}
    assert_select 'div[href=?]', edit_volunteer_path(@volunteer)
  end

  test "Find volunteers with multiple interests and name" do
    log_in_as(@user)
    @volunteer = Volunteer.new(first_name: "Tim", last_name: "Smith", email: "tim@eschers.com", interests: [@interest])
    @volunteer.save
    get search_volunteers_path
    assert_template 'volunteers/search'
    get volunteers_path, {interest_ids: [@interest.id, "0"], last_name: "s"}
    assert_select 'div[href=?]', edit_volunteer_path(@volunteer)
  end


end