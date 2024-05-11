class ContentsController < ApplicationController
  before_action :set_content, only: %i[ edit update destroy ]

  def new
    @content = Content.new
    authorize @content
  end

  def edit
  end

  def create
    @content = Content.new(content_params)
    authorize @content

    respond_to do |format|
      if @content.save
        format.html { redirect_to content_url(@content), notice: "Content was successfully created." }
        format.json { render :show, status: :created, location: @content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to content_url(@content), notice: "Content was successfully updated." }
        format.json { render :show, status: :ok, location: @content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1 or /contents/1.json
  def destroy
    @content.destroy

    respond_to do |format|
      format.html { redirect_to contents_url, notice: "Content was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_content
    @content = Content.find(params[:id])
    authorize @content
  end

  def content_params
    params.require(:content).permit(:header_background, :header_title_ca, :header_title_es, :header_title_en, :header_title_fr, :action_phrase_ca, :action_phrase_es, :action_phrase_en, :action_phrase_fr, :action_button_ca, :action_button_es, :action_button_en, :action_button_fr, :reviews_title_ca, :reviews_title_es, :reviews_title_en, :reviews_title_fr, :reviews_subtitle_ca, :reviews_subtitle_es, :reviews_subtitle_en, :reviews_subtitle_fr, :add_property_title_ca, :add_property_title_es, :add_property_title_en, :add_property_title_fr, :add_property_subtitle_ca, :add_property_subtitle_es, :add_property_subtitle_en, :add_property_subtitle_fr, :posts_title_ca, :posts_title_es, :posts_title_en, :posts_title_fr, :posts_subtitle_ca, :posts_subtitle_es, :posts_subtitle_en, :posts_subtitle_fr, :contact_title_ca, :contact_title_es, :contact_title_en, :contact_title_fr, :contact_subtitle_ca, :contact_subtitle_es, :contact_subtitle_en, :contact_subtitle_fr)
  end
end
