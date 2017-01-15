class Admin::JobsController < ApplicationController
  before_action :authenticate_user!, only:[:new, :create, :edit, :update, :destroy]
  before_action :require_is_admin
  layout "admin"

  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      flash[:warning] = "此工作岗位信息不存在"
      redirect_to root_path
    end
  end
  def index
    @jobs = Job.all.order("created_at DESC")
  end
  def new
    @job = Job.new
  end
  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end
  def edit
    @job = Job.find(params[:id])
  end
  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to admin_jobs_path
    else
      render :new
    end
  end
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    redirect_to admin_jobs_path
  end
  def publish
    @job = Job.find(params[:id])
    @job.publish!
    redirect_to :back
  end
  def hide
    @job = Job.find(params[:id])
    @job.hide!
    redirect_to :back
  end


  private
  def job_params
    params.require(:job).permit(:title,:description,
    :wage_upper_bound, :wage_lower_bound,:contact_email,:is_hidden)
  end
end
