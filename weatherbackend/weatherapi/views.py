from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import requests
import json

@csrf_exempt
def get_weather(request):
    if request.method == 'GET':
        city = request.GET.get('city', 'London')
        api_key = '60bb9f24db6c8d581aa11b9d9c7f80c3'
        url = f'https://api.openweathermap.porg/data/2.5/forecast?q={city}&appid={api_key}&units=metric&cnt=5'
        
        try:
            response = requests.get(url)
            data = response.json()
            
            if response.status_code == 200:
                processed_data = {
                    'city': data['city']['name'],
                    'current': {
                        'temp': data['list'][0]['main']['temp'],
                        'feels_like': data['list'][0]['main']['feels_like'],
                        'description': data['list'][0]['weather'][0]['description'],
                        'icon': data['list'][0]['weather'][0]['icon'],
                        'humidity': data['list'][0]['main']['humidity'],
                        'wind': data['list'][0]['wind']['speed'],
                    },
                    'forecast': [
                        {
                            'date': item['dt_txt'],
                            'temp': item['main']['temp'],
                            'icon': item['weather'][0]['icon']
                        } for item in data['list'][1:5]
                    ]
                }
                return JsonResponse(processed_data)
            return JsonResponse({'error': 'City not found'}, status=400)
                
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)