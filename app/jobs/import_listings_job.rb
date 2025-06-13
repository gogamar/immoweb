class ImportListingsJob < ApplicationJob
  queue_as :default
  require 'nokogiri'
  require 'net/ftp'

  def perform()
    GetPropertiesService.new.call
  end
end
