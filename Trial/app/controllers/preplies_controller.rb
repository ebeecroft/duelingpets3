class PrepliesController < ApplicationController
  # GET /preplies
  # GET /preplies.json
  def index
    @preplies = Preply.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @preplies }
    end
  end

  # GET /preplies/1
  # GET /preplies/1.json
  def show
    @preply = Preply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @preply }
    end
  end

  # GET /preplies/new
  # GET /preplies/new.json
  def new
    @preply = Preply.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @preply }
    end
  end

  # GET /preplies/1/edit
  def edit
    @preply = Preply.find(params[:id])
  end

  # POST /preplies
  # POST /preplies.json
  def create
    @preply = Preply.new(params[:preply])

    respond_to do |format|
      if @preply.save
        format.html { redirect_to @preply, notice: 'Preply was successfully created.' }
        format.json { render json: @preply, status: :created, location: @preply }
      else
        format.html { render action: "new" }
        format.json { render json: @preply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /preplies/1
  # PUT /preplies/1.json
  def update
    @preply = Preply.find(params[:id])

    respond_to do |format|
      if @preply.update_attributes(params[:preply])
        format.html { redirect_to @preply, notice: 'Preply was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @preply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preplies/1
  # DELETE /preplies/1.json
  def destroy
    @preply = Preply.find(params[:id])
    @preply.destroy

    respond_to do |format|
      format.html { redirect_to preplies_url }
      format.json { head :no_content }
    end
  end
end
