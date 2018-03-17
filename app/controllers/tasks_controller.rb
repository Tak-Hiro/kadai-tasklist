class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.all.page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = current_user.tasks.build
  end
  
  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'TASK が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'TASK が投稿されませんでした'
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'TASK は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'TASK は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'TASK は正常に削除されました'
    redirect_to tasks_url
  end
 
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end

  private
  
  def correct_user
    unless @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url
    end
  end
end