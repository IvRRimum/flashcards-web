class FlashcardsController < ApplicationController
  FLASHCARD_ANSWERS_PER_PAGE = 50

  before_action :authenticate_member!

  def new
    @flashcard_category = current_member.flashcard_categories.find(params[:flashcard_category_id])
    @flashcard = Flashcard.new(flashcard_category_id: params[:flashcard_category_id])
  end

  def create
    @flashcard_category = current_member.flashcard_categories.find(flashcard_params[:flashcard_category_id])
    @flashcard = Flashcard.new(flashcard_params)
    @flashcard.member = current_member

    if @flashcard.save
      flash[:notice] = "Flashcard created successfully!"
      redirect_to flashcard_path(@flashcard.id)
    else
      flash[:alert] = "Flashcard creation failed!"
      render :new
    end
  end

  def edit
    @flashcard = current_member.flashcards.find(params[:id])
  end

  def update
    @flashcard = current_member.flashcards.find(params[:id])

    if @flashcard.update(flashcard_params)
      flash[:notice] = "Flashcard updated successfully!"
      redirect_to flashcard_path(@flashcard.id)
    else
      flash[:alert] = "Flashcard updation failed!"
      render :edit
    end

  end

  def destroy
    @flashcard = current_member.flashcards.find(params[:id])
    if @flashcard.destroy
      flash[:notice] = "Flashcard deleted successfully!"
      redirect_to flashcard_category_path(@flashcard.flashcard_category_id)
    else
      flash[:alert] = "Flashcard deletion failed!"
      redirect_to flashcard_path(params[:id])
    end
  end

  def show
    @flashcard = current_member.flashcards.find(params[:id])
    @flashcard_answers = @flashcard.flashcard_answers.all.order(id: :desc).page(params[:page]).per(FLASHCARD_ANSWERS_PER_PAGE)
  end

  private

  def flashcard_params
    params.require(:flashcard).permit(:english, :hanzi, :pinyin, :flashcard_category_id)
  end
end
