class ImportListingsJob < ApplicationJob
  queue_as :default
  require 'nokogiri'
  require 'net/ftp'

  def perform()
    GetPropertiesService.new.get_properties
  end
end
