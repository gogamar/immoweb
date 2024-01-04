class ImageUrlsController < ApplicationController
  before_action :set_image_url, only: %i[ show edit update destroy ]

  # GET /image_urls or /image_urls.json
  def index
    @image_urls = ImageUrl.all
  end

  # GET /image_urls/1 or /image_urls/1.json
  def show
  end

  # GET /image_urls/new
  def new
    @image_url = ImageUrl.new
  end

  # GET /image_urls/1/edit
  def edit
  end

  # POST /image_urls or /image_urls.json
  def create
    @image_url = ImageUrl.new(image_url_params)

    respond_to do |format|
      if @image_url.save
        format.html { redirect_to image_url_url(@image_url), notice: "Image url was successfully created." }
        format.json { render :show, status: :created, location: @image_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_urls/1 or /image_urls/1.json
  def update
    respond_to do |format|
      if @image_url.update(image_url_params)
        format.html { redirect_to image_url_url(@image_url), notice: "Image url was successfully updated." }
        format.json { render :show, status: :ok, location: @image_url }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_urls/1 or /image_urls/1.json
  def destroy
    @image_url.destroy

    respond_to do |format|
      format.html { redirect_to image_urls_url, notice: "Image url was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_url
      @image_url = ImageUrl.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def image_url_params
      params.require(:image_url).permit(:caption, :url, :listing_id)
    end
end
