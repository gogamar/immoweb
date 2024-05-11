require "test_helper"

class ContentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @content = contents(:one)
  end

  test "should get index" do
    get contents_url
    assert_response :success
  end

  test "should get new" do
    get new_content_url
    assert_response :success
  end

  test "should create content" do
    assert_difference("Content.count") do
      post contents_url, params: { content: { action_button_ca: @content.action_button_ca, action_button_en: @content.action_button_en, action_button_es: @content.action_button_es, action_button_fr: @content.action_button_fr, action_phrase_ca: @content.action_phrase_ca, action_phrase_en: @content.action_phrase_en, action_phrase_es: @content.action_phrase_es, action_phrase_fr: @content.action_phrase_fr, contact_subtitle: @content.contact_subtitle, contact_title: @content.contact_title, header_title_ca: @content.header_title_ca, header_title_en: @content.header_title_en, header_title_es: @content.header_title_es, header_title_fr: @content.header_title_fr, reviews_title: @content.reviews_title } }
    end

    assert_redirected_to content_url(Content.last)
  end

  test "should show content" do
    get content_url(@content)
    assert_response :success
  end

  test "should get edit" do
    get edit_content_url(@content)
    assert_response :success
  end

  test "should update content" do
    patch content_url(@content), params: { content: { action_button_ca: @content.action_button_ca, action_button_en: @content.action_button_en, action_button_es: @content.action_button_es, action_button_fr: @content.action_button_fr, action_phrase_ca: @content.action_phrase_ca, action_phrase_en: @content.action_phrase_en, action_phrase_es: @content.action_phrase_es, action_phrase_fr: @content.action_phrase_fr, contact_subtitle: @content.contact_subtitle, contact_title: @content.contact_title, header_title_ca: @content.header_title_ca, header_title_en: @content.header_title_en, header_title_es: @content.header_title_es, header_title_fr: @content.header_title_fr, reviews_title: @content.reviews_title } }
    assert_redirected_to content_url(@content)
  end

  test "should destroy content" do
    assert_difference("Content.count", -1) do
      delete content_url(@content)
    end

    assert_redirected_to contents_url
  end
end
