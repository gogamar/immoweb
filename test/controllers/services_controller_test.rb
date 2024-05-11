require "test_helper"

class ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:one)
  end

  test "should get index" do
    get services_url
    assert_response :success
  end

  test "should get new" do
    get new_service_url
    assert_response :success
  end

  test "should create service" do
    assert_difference("Service.count") do
      post services_url, params: { service: { description_ca: @service.description_ca, description_en: @service.description_en, description_es: @service.description_es, description_fr: @service.description_fr, description_title_ca: @service.description_title_ca, description_title_en: @service.description_title_en, description_title_es: @service.description_title_es, description_title_fr: @service.description_title_fr, summary_ca: @service.summary_ca, summary_en: @service.summary_en, summary_es: @service.summary_es, summary_fr: @service.summary_fr, summary_title_ca: @service.summary_title_ca, summary_title_en: @service.summary_title_en, summary_title_es: @service.summary_title_es, summary_title_fr: @service.summary_title_fr } }
    end

    assert_redirected_to service_url(Service.last)
  end

  test "should show service" do
    get service_url(@service)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_url(@service)
    assert_response :success
  end

  test "should update service" do
    patch service_url(@service), params: { service: { description_ca: @service.description_ca, description_en: @service.description_en, description_es: @service.description_es, description_fr: @service.description_fr, description_title_ca: @service.description_title_ca, description_title_en: @service.description_title_en, description_title_es: @service.description_title_es, description_title_fr: @service.description_title_fr, summary_ca: @service.summary_ca, summary_en: @service.summary_en, summary_es: @service.summary_es, summary_fr: @service.summary_fr, summary_title_ca: @service.summary_title_ca, summary_title_en: @service.summary_title_en, summary_title_es: @service.summary_title_es, summary_title_fr: @service.summary_title_fr } }
    assert_redirected_to service_url(@service)
  end

  test "should destroy service" do
    assert_difference("Service.count", -1) do
      delete service_url(@service)
    end

    assert_redirected_to services_url
  end
end
