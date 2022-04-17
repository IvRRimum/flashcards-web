class FlashcardCategoriesController < ApplicationController
  FLASHCARD_ANSWERS_PER_PAGE = 50

  before_action :authenticate_member!
  before_action :set_flashcard_category, only: %i[ show edit update destroy ]

  # GET /flashcard_categories or /flashcard_categories.json
  def index
    @flashcard_categories = current_member.flashcard_categories.all
  end

  # GET /flashcard_categories/1 or /flashcard_categories/1.json
  def show
    @flashcards = @flashcard_category.flashcards.all
    @flashcard_answers = @flashcard_category.flashcard_answers.all.order(id: :desc).page(params[:page]).per(FLASHCARD_ANSWERS_PER_PAGE)
  end

  # GET /flashcard_categories/new
  def new
    @flashcard_category = FlashcardCategory.new
  end

  # GET /flashcard_categories/1/edit
  def edit
  end

  # POST /flashcard_categories or /flashcard_categories.json
  def create
    @flashcard_category = FlashcardCategory.new(flashcard_category_params)
    @flashcard_category.member = current_member

    respond_to do |format|
      if @flashcard_category.save
        format.html { redirect_to flashcard_category_url(@flashcard_category), notice: "Flashcard category was successfully created." }
        format.json { render :show, status: :created, location: @flashcard_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flashcard_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flashcard_categories/1 or /flashcard_categories/1.json
  def update
    respond_to do |format|
      if @flashcard_category.update(flashcard_category_params)
        format.html { redirect_to flashcard_category_url(@flashcard_category), notice: "Flashcard category was successfully updated." }
        format.json { render :show, status: :ok, location: @flashcard_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flashcard_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flashcard_categories/1 or /flashcard_categories/1.json
  def destroy
    @flashcard_category.destroy

    respond_to do |format|
      format.html { redirect_to flashcard_categories_url, notice: "Flashcard category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def play
    @flashcard_category = current_member.flashcard_categories.find(params[:flashcard_category_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flashcard_category
      @flashcard_category = current_member.flashcard_categories.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def flashcard_category_params
      params.require(:flashcard_category).permit(:title, :note)
    end
end
