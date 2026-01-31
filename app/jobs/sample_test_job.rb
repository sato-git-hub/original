class SampleTestJob < ApplicationJob
  queue_as :default

  def perform(message)
    puts "----------------------------------------"
    puts "SampleTestJob 実行中: #{message}"
    puts "実行時刻: #{Time.current}"
    puts "----------------------------------------"
    Rails.logger.info "SampleTestJob が正常に動作しました: #{message}"
  end
end
