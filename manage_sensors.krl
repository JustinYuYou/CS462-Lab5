ruleset manage_sensors {
   rule manage {
      select when sensor new_sensor
   }

   rule manageef {
      select when sensor unneeded_sensor
   }
}