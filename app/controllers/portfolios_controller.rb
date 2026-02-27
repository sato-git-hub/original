class PortfoliosController < ApplicationController
  def index
    @portfolios = CreatorSetting.where(published: true)
  end
end
