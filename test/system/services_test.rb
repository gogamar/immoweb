require "application_system_test_case"

class ServicesTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "visiting the index" do
    visit services_url
    assert_selector "h1", text: "Services"
  end

  test "should create service" do
    visit services_url
    click_on t('add_service')

    fill_in "Description ca", with: @service.description_ca
    fill_in "Description en", with: @service.description_en
    fill_in "Description es", with: @service.description_es
    fill_in "Description fr", with: @service.description_fr
    fill_in "Description title ca", with: @service.description_title_ca
    fill_in "Description title en", with: @service.description_title_en
    fill_in "Description title es", with: @service.description_title_es
    fill_in "Description title fr", with: @service.description_title_fr
    fill_in "Summary ca", with: @service.summary_ca
    fill_in "Summary en", with: @service.summary_en
    fill_in "Summary es", with: @service.summary_es
    fill_in "Summary fr", with: @service.summary_fr
    fill_in "Summary title ca", with: @service.summary_title_ca
    fill_in "Summary title en", with: @service.summary_title_en
    fill_in "Summary title es", with: @service.summary_title_es
    fill_in "Summary title fr", with: @service.summary_title_fr
    click_on "Create Service"

    assert_text "Service was successfully created"
    click_on "Back"
  end

  test "should update Service" do
    visit service_url(@service)
    click_on "Edit this service", match: :first

    fill_in "Description ca", with: @service.description_ca
    fill_in "Description en", with: @service.description_en
    fill_in "Description es", with: @service.description_es
    fill_in "Description fr", with: @service.description_fr
    fill_in "Description title ca", with: @service.description_title_ca
    fill_in "Description title en", with: @service.description_title_en
    fill_in "Description title es", with: @service.description_title_es
    fill_in "Description title fr", with: @service.description_title_fr
    fill_in "Summary ca", with: @service.summary_ca
    fill_in "Summary en", with: @service.summary_en
    fill_in "Summary es", with: @service.summary_es
    fill_in "Summary fr", with: @service.summary_fr
    fill_in "Summary title ca", with: @service.summary_title_ca
    fill_in "Summary title en", with: @service.summary_title_en
    fill_in "Summary title es", with: @service.summary_title_es
    fill_in "Summary title fr", with: @service.summary_title_fr
    click_on "Update Service"

    assert_text "Service was successfully updated"
    click_on "Back"
  end

  test "should destroy Service" do
    visit service_url(@service)
    click_on "Destroy this service", match: :first

    assert_text "Service was successfully destroyed"
  end
end
