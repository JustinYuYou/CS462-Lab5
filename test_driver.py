import requests
def create_sensor():
   url = "http://localhost:3000/sky/event/ckzx9ry4n0006h8p39w9v07kr/1556/manage_sensors/new_sensor"
   body = {
      "sensor_name": "justin_sensor"
   }
   response = requests.post('url', data=body)

def get_temps():
   url = "http://localhost:3000/sky/cloud/ckzx9ry4n0006h8p39w9v07kr/temperature_store/temperatures"
   response = requests.get('url')

def update_profile():
