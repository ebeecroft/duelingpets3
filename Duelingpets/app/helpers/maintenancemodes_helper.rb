module MaintenancemodesHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         logged_in = current_user
         if(logged_in)
            if(logged_in.admin)
               switch(type)
            else
               redirect_to root_path
            end
         else
            redirect_to root_path
         end
      end
   end

   private
      def switch(type)
         if(type == "index") #Admin only
            allModes = Maintenancemode.order("id").page(params[:page]).per(10)
            @maintenancemodes = allModes
         elsif(type == "new") #Admin only
            @maintenancemode = Maintenancemode.new
         elsif(type == "create") #Admin only
            newMaintenancemode = Maintenancemode.new(params[:maintenancemode])
            currentTime = Time.now
            newMaintenancemode.created_on = currentTime
            @maintenancemode = newMaintenancemode
            if(@maintenancemode.save)
               flash[:success] = "#{@maintenancemode.name} was successfully created."
               redirect_to maintenancemodes_url
            else
               render "new"
            end
         elsif(type == "edit") #Admin only
            maintenancemodeFound = Maintenancemode.find_by_id(params[:id])
            if(maintenancemodeFound)
               @maintenancemode = maintenancemodeFound
            else
               render "public/404"
            end
         elsif(type == "update") #Admin only
            maintenancemodeFound = Maintenancemode.find_by_id(params[:id])
            if(maintenancemodeFound)
               @maintenancemode = maintenancemodeFound
               if(@maintenancemode.update_attributes(params[:maintenancemode]))
                  flash[:success] = "#{@maintenancemode.name} was successfully updated."
                  redirect_to maintenancemodes_url
               else
                  render "edit"
               end
            else
               render "public/404"
            end
         end
      end
end
