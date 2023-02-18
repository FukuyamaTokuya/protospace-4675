class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new,:edit,:destroy]
  before_action :move_to_index, only: :edit
  
  def index
    @prototypes=Prototype.includes(:user)
  end

  def new
    @prototype=Prototype.new
  end

  def create
    # binding.pry
    @prototype=Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      #@prototype=Prototype.new(prototype_params)
      render :new
    end
  end

  def show
   @prototype=Prototype.find(params[:id])
   @comment=@prototype.comments.new
   @comments=@prototype.comments.all
  end

  def edit
    @prototype=Prototype.find(params[:id])
  end

  def update
    @prototype=Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    Prototype.find(params[:id]).destroy
    redirect_to root_path
  end

  private 
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    prototype=Prototype.find(params[:id])
      unless current_user.id == prototype.user.id 
        redirect_to root_path
      end
  end
end
