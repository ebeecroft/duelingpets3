class AccountkeysController < ApplicationController
  # GET /accountkeys
  # GET /accountkeys.json
  def index
    @accountkeys = Accountkey.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accountkeys }
    end
  end

  # GET /accountkeys/1
  # GET /accountkeys/1.json
  def show
    @accountkey = Accountkey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accountkey }
    end
  end

  # GET /accountkeys/new
  # GET /accountkeys/new.json
  def new
    @accountkey = Accountkey.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accountkey }
    end
  end

  # GET /accountkeys/1/edit
  def edit
    @accountkey = Accountkey.find(params[:id])
  end

  # POST /accountkeys
  # POST /accountkeys.json
  def create
    @accountkey = Accountkey.new(params[:accountkey])

    respond_to do |format|
      if @accountkey.save
        format.html { redirect_to @accountkey, notice: 'Accountkey was successfully created.' }
        format.json { render json: @accountkey, status: :created, location: @accountkey }
      else
        format.html { render action: "new" }
        format.json { render json: @accountkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accountkeys/1
  # PUT /accountkeys/1.json
  def update
    @accountkey = Accountkey.find(params[:id])

    respond_to do |format|
      if @accountkey.update_attributes(params[:accountkey])
        format.html { redirect_to @accountkey, notice: 'Accountkey was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @accountkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accountkeys/1
  # DELETE /accountkeys/1.json
  def destroy
    @accountkey = Accountkey.find(params[:id])
    @accountkey.destroy

    respond_to do |format|
      format.html { redirect_to accountkeys_url }
      format.json { head :no_content }
    end
  end
end
