ruleset manage_sensors {
   meta {
      shares creat_sensor, sensors
      use module io.picolabs.wrangler alias wrangler
   }

   global {
      sensors = function() {
         ent:sensors
      }
      all_sensors_temperatures = function() {
         ent:sensors.map(function(v, k){
            eci = v{"eci"}
            wrangler:picoQuery(eci,"temperature_store","current_temp");
         })
      }
   }

   rule intialization {
      select when wrangler ruleset_installed where event:attrs{"rids"} >< meta:rid
      fired {
         ent:sensors := {}
      }
   }

   rule creat_sensor {
      select when sensor new_sensor
         foreach ["temperature_store","wovyn_base","sensor_profile","io.picolabs.wovyn.emitter"]
      
      pre {
         sensor_name = event:attr("sensor_name")
         eci = event:attr("eci")
      }

      if not sensor_name >< sensor_names then
         event:send(
            { 
              "eci": eci, 
              "eid": "install-ruleset",
              "domain": "wrangler", 
              "type": "install_ruleset_request",
              "attrs": {
                "absoluteURL": meta:rulesetURI,
                "rid": "manage_sensors",
                "sensor_name": sensor_name
              }
            }
         )
      
      fired {
         raise wrangler event "new_child_request"
            attributes { "name": sensor_name, "backgroundColor": "#ff69b4" }
        
         ent:sensors{sensor_name} := { 
            "eci": eci
         }
      }
   }

   rule update_profile {
      select when sensor profile_updated
      event:send(

      )
   }

   rule delete_sensor {
      select when sensor unneeded_sensor
      pre{
         sensor_name = event:attr{"sensor_name"}
         exists = ent:sensors >< deleted_sensor_name 
         eci_to_delete = ent:sensors{[sensor_name,"eci"]}
      }
      if exists && eci_to_delete then
        send_directive("deleting_sensor", {"sensor_name":sensor_name})
      
      fired {
        raise wrangler event "child_deletion_request"
          attributes {"eci": eci_to_delete};
        clear ent:sensors{sensor_name}
      }
   }
}

// how to install ruleset?