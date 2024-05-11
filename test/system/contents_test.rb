require "application_system_test_case"

class ContentsTest < ApplicationSystemTestCase
  setup do
    @content = contents(:one)
  end

  test "visiting the index" do
    visit contents_url
    assert_selector "h1", text: "Contents"
  end

  test "should create content" do
    visit contents_url
    click_on "New content"

    fill_in "Action button ca", with: @content.action_button_ca
    fill_in "Action button en", with: @content.action_button_en
    fill_in "Action button es", with: @content.action_button_es
    fill_in "Action button fr", with: @content.action_button_fr
    fill_in "Action phrase ca", with: @content.action_phrase_ca
    fill_in "Action phrase en", with: @content.action_phrase_en
    fill_in "Action phrase es", with: @content.action_phrase_es
    fill_in "Action phrase fr", with: @content.action_phrase_fr
    fill_in "Contact subtitle", with: @content.contact_subtitle
    fill_in "Contact title", with: @content.contact_title
    fill_in "Header title ca", with: @content.header_title_ca
    fill_in "Header title en", with: @content.header_title_en
    fill_in "Header title es", with: @content.header_title_es
    fill_in "Header title fr", with: @content.header_title_fr
    fill_in "Reviews title", with: @content.reviews_title
    click_on "Create Content"

    assert_text "Content was successfully created"
    click_on "Back"
  end

  test "should update Content" do
    visit content_url(@content)
    click_on "Edit this content", match: :first

    fill_in "Action button ca", with: @content.action_button_ca
    fill_in "Action button en", with: @content.action_button_en
    fill_in "Action button es", with: @content.action_button_es
    fill_in "Action button fr", with: @content.action_button_fr
    fill_in "Action phrase ca", with: @content.action_phrase_ca
    fill_in "Action phrase en", with: @content.action_phrase_en
    fill_in "Action phrase es", with: @content.action_phrase_es
    fill_in "Action phrase fr", with: @content.action_phrase_fr
    fill_in "Contact subtitle", with: @content.contact_subtitle
    fill_in "Contact title", with: @content.contact_title
    fill_in "Header title ca", with: @content.header_title_ca
    fill_in "Header title en", with: @content.header_title_en
    fill_in "Header title es", with: @content.header_title_es
    fill_in "Header title fr", with: @content.header_title_fr
    fill_in "Reviews title", with: @content.reviews_title
    click_on "Update Content"

    assert_text "Content was successfully updated"
    click_on "Back"
  end

  test "should destroy Content" do
    visit content_url(@content)
    click_on "Destroy this content", match: :first

    assert_text "Content was successfully destroyed"
  end
end
