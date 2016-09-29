class BlacklistednamesController < ApplicationController
  # GET /blacklistednames
  # GET /blacklistednames.json
  def index
    @blacklistednames = Blacklistedname.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blacklistednames }
    end
  end

  # GET /blacklistednames/1
  # GET /blacklistednames/1.json
  def show
    @blacklistedname = Blacklistedname.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @blacklistedname }
    end
  end

  # GET /blacklistednames/new
  # GET /blacklistednames/new.json
  def new
    @blacklistedname = Blacklistedname.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blacklistedname }
    end
  end

  # GET /blacklistednames/1/edit
  def edit
    @blacklistedname = Blacklistedname.find(params[:id])
  end

  # POST /blacklistednames
  # POST /blacklistednames.json
  def create
    @blacklistedname = Blacklistedname.new(params[:blacklistedname])

    respond_to do |format|
      if @blacklistedname.save
        format.html { redirect_to @blacklistedname, notice: 'Blacklistedname was successfully created.' }
        format.json { render json: @blacklistedname, status: :created, location: @blacklistedname }
      else
        format.html { render action: "new" }
        format.json { render json: @blacklistedname.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blacklistednames/1
  # PUT /blacklistednames/1.json
  def update
    @blacklistedname = Blacklistedname.find(params[:id])

    respond_to do |format|
      if @blacklistedname.update_attributes(params[:blacklistedname])
        format.html { redirect_to @blacklistedname, notice: 'Blacklistedname was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blacklistedname.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blacklistednames/1
  # DELETE /blacklistednames/1.json
  def destroy
    @blacklistedname = Blacklistedname.find(params[:id])
    @blacklistedname.destroy

    respond_to do |format|
      format.html { redirect_to blacklistednames_url }
      format.json { head :no_content }
    end
  end
end
