require 'test_helper'

class ProjectsEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @project = projects(:one)
    @project_2 = projects(:two)
    @non_admin = users(:one)
  end

  test "No edits by non-admin" do
    log_in_as(@non_admin)
    get edit_project_path(@project)
    assert_redirected_to root_url
  end

  test "No imports by non-admin" do
    log_in_as(@non_admin)
    get import_projects_path
    assert_redirected_to root_url
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_project_path(@project)
    assert_template 'shared/simple_edit'
    patch project_path(@project), project: { name:  "" }
    assert_template 'shared/simple_edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_project_path(@project)
    assert_template 'shared/simple_edit'
    name  = "Foo"
    patch project_path(@project), project: { name:  name }
    assert_not flash.empty?
    assert_redirected_to projects_url
    @project.reload
    assert_equal @project.name,  name
  end

  test "successful edit with friendly forwarding" do
    get edit_project_path(@project)
    log_in_as(@user)
    assert_redirected_to edit_project_path(@project)
    name  = "Foo"
    patch project_path(@project), project: { name:  name }
    assert_not flash.empty?
    assert_redirected_to projects_url
    @project.reload
    assert_equal @project.name,  name
  end

  test "successful delete as admin" do
    log_in_as(@user)
    get edit_project_path(@project_2)
    assert_select 'a[href=?]', project_path(@project_2), method: :delete

    assert_difference 'Project.count', -1 do
      delete project_path(@project_2)
    end
  end

  test "no delete if attached to a workday" do
    log_in_as(@user)
    @workday = workdays(:one)
    @workday.project = @project
    @workday.save
    get edit_project_path(@project)
    assert_select 'a[href=?]', project_path(@project), method: :delete

    assert_no_difference 'Project.count' do
      delete project_path(@project)
    end
  end

  test "no duplicate creation" do
    log_in_as(@user)
    get edit_project_path(@project_2)
    assert_template 'shared/simple_edit'
    name  = @project.name
    patch project_path(@project_2), project: { name:  name }
    assert_select '.alert', 1
    @project_2.reload
    assert_not_equal @project_2.name,  name

  end


end