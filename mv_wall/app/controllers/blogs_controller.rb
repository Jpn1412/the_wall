class BlogsController < ApplicationController
  def index
    if session[:user].nil? || session[:user].empty?
      redirect_to '/login'
    else
      get_messages
      @user = session[:user]
    end
  end

  def get_messages
    @data = Blog.get_all
  end 

  def logout
    session.clear
    redirect_to '/login'
  end
end
