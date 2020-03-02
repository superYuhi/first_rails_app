class HomeController < ApplicationController

  def top
    @users_count = User.all.count
    @posts_count = Post.all.count    
  end

end
