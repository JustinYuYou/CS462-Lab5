ruleset manage_sensors {
   meta {
      shares sensors
      use module io.picolabs.wrangler alias wrangler
   }

   global {
      sensors = function() {
         ent:sensors
      }

      all_sensors_temperatures = function() {
         ent:sensors.map(function(v, k){
            eci = v{"eci"}
            wrangler:picoQuery(eci,"temperature_store","temperatures");
         })
      }
   }

   rule intialization {
      select when wrangler ruleset_installed where event:attrs{"rids"} >< meta:rid
      fired {
         ent:sensors := {}
      }
   }

   rule create_sensor {
      select when sensor new_sensor
      pre {
         sensor_name = event:attr("sensor_name")
      }
      
      always {
         raise wrangler event "new_child_request"
            attributes { "name": sensor_name, "backgroundColor": "#ff69b4" }
      }
   }

   rule create_child {
      select when wrangler new_child_created
         foreach ["temperature_store","wovyn_base","sensor_profile","io.picolabs.wovyn.emitter"] setting(rs)
      
      pre {
         sensor_name = event:attr("name")
         eci = event:attr("eci")
      }

      if not sensor_name >< ent:sensors then
         event:send(
            { 
              "eci": eci, 
              "eid": "install-ruleset",
              "domain": "wrangler", 
              "type": "install_ruleset_request",
              "attrs": {
                "absoluteURL": meta:rulesetURI,
                "rid": rs,
              }
            }
         )
      
      fired {
         ent:sensors{sensor_name} := { 
            "eci": eci
         } on final
      }
   }

   rule update_profile {
      select when sensor profile_updated
      pre {
         eci = event:attr("eci")
         sensor_name = event:attr("sensor_name")
         threshold = event:attr("threshold")
         sms_number = event:attr("sms_number")

      }

      event:send(
         { 
            "eci": eci, 
            "eid": "update-profile",
            "domain": "wrangler", 
            "type": "profile_updated",
            "attrs": {
              "absoluteURL": meta:rulesetURI,
              "rid": rs,
              "sensor_name": sensor_name,
              "threshold": threshold,
              "sms_number": sms_number
            }
          }
      )
   }

   rule delete_sensor {
      select when sensor unneeded_sensor
      pre{
         deleted_sensor_name = event:attr{"sensor_name"}
         exists = ent:sensors >< deleted_sensor_name 
         eci_to_delete = ent:sensors{[deleted_sensor_name,"eci"]}
      }
      if exists && eci_to_delete then
        send_directive("deleting_sensor", {"sensor_name":deleted_sensor_name})
      
      fired {
        raise wrangler event "child_deletion_request"
          attributes {"eci": eci_to_delete};
        clear ent:sensors{deleted_sensor_name}
      }
   }
}

// how to install ruleset?