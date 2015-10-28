require 'test_helper'

class InterestTest < ActiveSupport::TestCase

  def setup
    @interest_category = InterestCategory.new(name: "IT")
    @interest_category.save
    @interest = Interest.new(name: "Example", interest_category: @interest_category, highlight: true)
  end

  test "should be valid" do
    assert @interest.valid?
  end

  test "name should be present, category doesn't matter" do
    @interest.name = "     "
    assert_not @interest.valid?
    @interest.name = "Example"
    @interest.interest_category = nil
    assert_not @interest.valid?
  end

  test "Volunteer Association" do
    @interest = interests(:master)
    @volunteer = volunteers(:dependent)
    assert_raises(ActiveRecord::DeleteRestrictionError) {@interest.destroy}
  end

end
