class SubsheetsController < ApplicationController
  # GET /subsheets
  # GET /subsheets.json
  def index
    @subsheets = Subsheet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subsheets }
    end
  end

  # GET /subsheets/1
  # GET /subsheets/1.json
  def show
    @subsheet = Subsheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subsheet }
    end
  end

  # GET /subsheets/new
  # GET /subsheets/new.json
  def new
    @subsheet = Subsheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subsheet }
    end
  end

  # GET /subsheets/1/edit
  def edit
    @subsheet = Subsheet.find(params[:id])
  end

  # POST /subsheets
  # POST /subsheets.json
  def create
    @subsheet = Subsheet.new(params[:subsheet])

    respond_to do |format|
      if @subsheet.save
        format.html { redirect_to @subsheet, notice: 'Subsheet was successfully created.' }
        format.json { render json: @subsheet, status: :created, location: @subsheet }
      else
        format.html { render action: "new" }
        format.json { render json: @subsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subsheets/1
  # PUT /subsheets/1.json
  def update
    @subsheet = Subsheet.find(params[:id])

    respond_to do |format|
      if @subsheet.update_attributes(params[:subsheet])
        format.html { redirect_to @subsheet, notice: 'Subsheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subsheets/1
  # DELETE /subsheets/1.json
  def destroy
    @subsheet = Subsheet.find(params[:id])
    @subsheet.destroy

    respond_to do |format|
      format.html { redirect_to subsheets_url }
      format.json { head :no_content }
    end
  end
end
