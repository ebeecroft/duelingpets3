class BlacklisteddomainsController < ApplicationController
  # GET /blacklisteddomains
  # GET /blacklisteddomains.json
  def index
    @blacklisteddomains = Blacklisteddomain.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blacklisteddomains }
    end
  end

  # GET /blacklisteddomains/1
  # GET /blacklisteddomains/1.json
  def show
    @blacklisteddomain = Blacklisteddomain.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @blacklisteddomain }
    end
  end

  # GET /blacklisteddomains/new
  # GET /blacklisteddomains/new.json
  def new
    @blacklisteddomain = Blacklisteddomain.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blacklisteddomain }
    end
  end

  # GET /blacklisteddomains/1/edit
  def edit
    @blacklisteddomain = Blacklisteddomain.find(params[:id])
  end

  # POST /blacklisteddomains
  # POST /blacklisteddomains.json
  def create
    @blacklisteddomain = Blacklisteddomain.new(params[:blacklisteddomain])

    respond_to do |format|
      if @blacklisteddomain.save
        format.html { redirect_to @blacklisteddomain, notice: 'Blacklisteddomain was successfully created.' }
        format.json { render json: @blacklisteddomain, status: :created, location: @blacklisteddomain }
      else
        format.html { render action: "new" }
        format.json { render json: @blacklisteddomain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blacklisteddomains/1
  # PUT /blacklisteddomains/1.json
  def update
    @blacklisteddomain = Blacklisteddomain.find(params[:id])

    respond_to do |format|
      if @blacklisteddomain.update_attributes(params[:blacklisteddomain])
        format.html { redirect_to @blacklisteddomain, notice: 'Blacklisteddomain was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blacklisteddomain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blacklisteddomains/1
  # DELETE /blacklisteddomains/1.json
  def destroy
    @blacklisteddomain = Blacklisteddomain.find(params[:id])
    @blacklisteddomain.destroy

    respond_to do |format|
      format.html { redirect_to blacklisteddomains_url }
      format.json { head :no_content }
    end
  end
end
