class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully created a new video."
      redirect_to new_admin_video_path
    else
      flash.now[:danger] = "The video was not created because there was an error with the input."
      render 'new'
    end
  end
  
  private
  
  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :video_url)
  end
end
