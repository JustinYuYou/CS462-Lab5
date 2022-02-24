import requests
def create_sensor(sensor_name):
   url = "http://localhost:3000/sky/event/ckzzuyk6d0048bsp30dsu6izl/none/sensor/new_sensor"
   body = {
      "sensor_name": sensor_name,
      "threshold": 10,
      "sms_number": "+123"
   }
   response = requests.post(url, data=body)
   print(response)
   print(response.json())
   
def delete_sensor(sensor_name):
   url = "http://localhost:3000/sky/event/ckzzuyk6d0048bsp30dsu6izl/1556/sensor/unneeded_sensor"
   body = {
      "sensor_name": sensor_name
   }
   response = requests.delete(url, data=body)

def get_sensors():
   url = "http://localhost:3000/sky/cloud/ckzzuyk6d0048bsp30dsu6izl/manage_sensors/sensors"
   response = requests.get(url)

   return response.json()

def get_temps():
   url = "http://localhost:3000/sky/cloud/ckzzuyk6d0048bsp30dsu6izl/temperature_store/temperatures"
   response = requests.get(url)
   return response.json()


def update_profile(sensor_name, threshold, sms_number):
   url = "http://localhost:3000/sky/event/cl00bdb9h00rwwep34qja9pm3/none/sensor/profile_updated"
   body = {
      "sensor_name": sensor_name,
      "threshold": threshold,
      "sms_number": sms_number
   }
   response = requests.post(url, data=body)
   
def test_create_delete_sensor():
   for i in range(3):
      create_sensor("justin_sensor"+str(i))
   
   sensors = get_sensors()
   assert len(sensors.keys()) == 3

   delete_sensor("justin_sensor1")

   sensors = get_sensors()
   assert len(sensors.keys()) == 2
   
   print("Create and Delete sensor passed!")
   
def test_create_delete_sensor():
   for i in range(3):
      create_sensor("justin_sensor"+str(i))
   
   sensors = get_sensors()
   assert len(sensors.keys()) == 3

   delete_sensor("justin_sensor1")

   sensors = get_sensors()
   assert len(sensors.keys()) == 2
   
   print("Create and Delete sensor passed!")
   
def test_update_sensor():
   update_profile("justin_sensor0", 10000, "+1111111")
   sensors = get_sensors()
   print("update sensor profile passed!")
   

if __name__ == '__main__':
   test_create_delete_sensor()
   test_update_sensor()