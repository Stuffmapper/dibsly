class DibsController < ApplicationController
  before_action :set_dib, only: [:show, :edit, :update, :destroy]

  # GET /dibs
  # GET /dibs.json
  def index
    @dibs = Dib.all
  end

  # GET /dibs/1
  # GET /dibs/1.json
  def show
  end

  # GET /dibs/new
  def new
    @dib = Dib.new
  end

  # GET /dibs/1/edit
  def edit
  end

  # POST /dibs
  # POST /dibs.json
  def create
    @dib = Dib.new(dib_params)

    respond_to do |format|
      if @dib.save
        format.html { redirect_to @dib, notice: 'Dib was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dib }
      else
        format.html { render action: 'new' }
        format.json { render json: @dib.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dibs/1
  # PATCH/PUT /dibs/1.json
  def update
    respond_to do |format|
      if @dib.update(dib_params)
        format.html { redirect_to @dib, notice: 'Dib was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dib.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dibs/1
  # DELETE /dibs/1.json
  def destroy
    @dib.destroy
    respond_to do |format|
      format.html { redirect_to dibs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dib
      @dib = Dib.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dib_params
      params.require(:dib).permit(:ip, :valid_until, :status, :creator_id, :post_id)
    end
end
