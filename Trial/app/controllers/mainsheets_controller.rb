class MainsheetsController < ApplicationController
  # GET /mainsheets
  # GET /mainsheets.json
  def index
    @mainsheets = Mainsheet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mainsheets }
    end
  end

  # GET /mainsheets/1
  # GET /mainsheets/1.json
  def show
    @mainsheet = Mainsheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mainsheet }
    end
  end

  # GET /mainsheets/new
  # GET /mainsheets/new.json
  def new
    @mainsheet = Mainsheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mainsheet }
    end
  end

  # GET /mainsheets/1/edit
  def edit
    @mainsheet = Mainsheet.find(params[:id])
  end

  # POST /mainsheets
  # POST /mainsheets.json
  def create
    @mainsheet = Mainsheet.new(params[:mainsheet])

    respond_to do |format|
      if @mainsheet.save
        format.html { redirect_to @mainsheet, notice: 'Mainsheet was successfully created.' }
        format.json { render json: @mainsheet, status: :created, location: @mainsheet }
      else
        format.html { render action: "new" }
        format.json { render json: @mainsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mainsheets/1
  # PUT /mainsheets/1.json
  def update
    @mainsheet = Mainsheet.find(params[:id])

    respond_to do |format|
      if @mainsheet.update_attributes(params[:mainsheet])
        format.html { redirect_to @mainsheet, notice: 'Mainsheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mainsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mainsheets/1
  # DELETE /mainsheets/1.json
  def destroy
    @mainsheet = Mainsheet.find(params[:id])
    @mainsheet.destroy

    respond_to do |format|
      format.html { redirect_to mainsheets_url }
      format.json { head :no_content }
    end
  end
end
