class PmsController < ApplicationController
   include PmsHelper

   def index
      mode "index"
   end

   def show
      mode "show"
   end

   def new
      mode "new"
   end

   def edit
      mode "edit"
   end

   def create
      mode "create"
   end

   def update
      mode "update"
   end

   def destroy
      mode "destroy"
   end

   def inbox
      mode "inbox"
   end

   def outbox
      mode "outbox"
   end
end
