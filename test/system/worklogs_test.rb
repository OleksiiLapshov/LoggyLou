require "application_system_test_case"

class WorklogsTest < ApplicationSystemTestCase
  setup do
    @worklog = worklogs(:one)
  end

  test "visiting the index" do
    visit worklogs_url
    assert_selector "h1", text: "Worklogs"
  end

  test "should create worklog" do
    visit worklogs_url
    click_on "New worklog"

    fill_in "Employee", with: @worklog.employee
    fill_in "Hours", with: @worklog.hours
    fill_in "Log date", with: @worklog.log_date
    fill_in "Note", with: @worklog.note
    fill_in "Project", with: @worklog.project
    click_on "Create Worklog"

    assert_text "Worklog was successfully created"
    click_on "Back"
  end

  test "should update Worklog" do
    visit worklog_url(@worklog)
    click_on "Edit this worklog", match: :first

    fill_in "Employee", with: @worklog.employee
    fill_in "Hours", with: @worklog.hours
    fill_in "Log date", with: @worklog.log_date
    fill_in "Note", with: @worklog.note
    fill_in "Project", with: @worklog.project
    click_on "Update Worklog"

    assert_text "Worklog was successfully updated"
    click_on "Back"
  end

  test "should destroy Worklog" do
    visit worklog_url(@worklog)
    click_on "Destroy this worklog", match: :first

    assert_text "Worklog was successfully destroyed"
  end
end
