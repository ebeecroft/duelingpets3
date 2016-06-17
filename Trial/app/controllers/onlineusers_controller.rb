class OnlineusersController < ApplicationController
  # GET /onlineusers
  # GET /onlineusers.json
  def index
    @onlineusers = Onlineuser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @onlineusers }
    end
  end

  # GET /onlineusers/1
  # GET /onlineusers/1.json
  def show
    @onlineuser = Onlineuser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @onlineuser }
    end
  end

  # GET /onlineusers/new
  # GET /onlineusers/new.json
  def new
    @onlineuser = Onlineuser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @onlineuser }
    end
  end

  # GET /onlineusers/1/edit
  def edit
    @onlineuser = Onlineuser.find(params[:id])
  end

  # POST /onlineusers
  # POST /onlineusers.json
  def create
    @onlineuser = Onlineuser.new(params[:onlineuser])

    respond_to do |format|
      if @onlineuser.save
        format.html { redirect_to @onlineuser, notice: 'Onlineuser was successfully created.' }
        format.json { render json: @onlineuser, status: :created, location: @onlineuser }
      else
        format.html { render action: "new" }
        format.json { render json: @onlineuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /onlineusers/1
  # PUT /onlineusers/1.json
  def update
    @onlineuser = Onlineuser.find(params[:id])

    respond_to do |format|
      if @onlineuser.update_attributes(params[:onlineuser])
        format.html { redirect_to @onlineuser, notice: 'Onlineuser was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @onlineuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /onlineusers/1
  # DELETE /onlineusers/1.json
  def destroy
    @onlineuser = Onlineuser.find(params[:id])
    @onlineuser.destroy

    respond_to do |format|
      format.html { redirect_to onlineusers_url }
      format.json { head :no_content }
    end
  end
end
