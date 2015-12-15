class HelpController < ApplicationController
  layout 'help'
  skip_before_action :authenticate_user!, only: [:index, :show]
  skip_before_action :check_disabled_client

  def index
    @pages = self.page_names.sort
  end

  def show
    page = params[:id]
    # prevent rendering of any non-help template
    if self.page_names.include?(page)
      render "help/#{page}"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end


  protected

  def page_names
    dir = Rails.root.join('app', 'views', 'help', '*.md')
    files = Dir.glob(dir)
    files.map{|file| File.basename(file, '.md') }
  end
end
