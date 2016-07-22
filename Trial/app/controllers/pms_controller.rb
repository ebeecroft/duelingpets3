class PmsController < ApplicationController
  # GET /pms
  # GET /pms.json
  def index
    @pms = Pm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pms }
    end
  end

  # GET /pms/1
  # GET /pms/1.json
  def show
    @pm = Pm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pm }
    end
  end

  # GET /pms/new
  # GET /pms/new.json
  def new
    @pm = Pm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pm }
    end
  end

  # GET /pms/1/edit
  def edit
    @pm = Pm.find(params[:id])
  end

  # POST /pms
  # POST /pms.json
  def create
    @pm = Pm.new(params[:pm])

    respond_to do |format|
      if @pm.save
        format.html { redirect_to @pm, notice: 'Pm was successfully created.' }
        format.json { render json: @pm, status: :created, location: @pm }
      else
        format.html { render action: "new" }
        format.json { render json: @pm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pms/1
  # PUT /pms/1.json
  def update
    @pm = Pm.find(params[:id])

    respond_to do |format|
      if @pm.update_attributes(params[:pm])
        format.html { redirect_to @pm, notice: 'Pm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pms/1
  # DELETE /pms/1.json
  def destroy
    @pm = Pm.find(params[:id])
    @pm.destroy

    respond_to do |format|
      format.html { redirect_to pms_url }
      format.json { head :no_content }
    end
  end
end
