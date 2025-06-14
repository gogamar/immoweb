class ImportListingsJob < ApplicationJob
  queue_as :default

  def perform
    GetPropertiesService.new.call
  end
end
