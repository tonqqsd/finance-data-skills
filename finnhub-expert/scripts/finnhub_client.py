import os
import sys
import requests
import json

def get_finnhub_data(endpoint, params=None):
    api_key = os.environ.get('FINNHUB_API_KEY')
    if not api_key:
        print("Error: FINNHUB_API_KEY environment variable is not set.")
        sys.exit(1)
    
    base_url = "https://finnhub.io/api/v1"
    url = f"{base_url}/{endpoint}"
    
    if params is None:
        params = {}
    params['token'] = api_key
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from Finnhub: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("Usage: python finnhub_client.py <endpoint> [json_params]")
        sys.exit(1)
    
    endpoint = sys.argv[1]
    params = {}
    if len(sys.argv) > 2:
        try:
            params = json.loads(sys.argv[2])
        except json.JSONDecodeError:
            print("Error: Invalid JSON params.")
            sys.exit(1)
            
    data = get_finnhub_data(endpoint, params)
    print(json.dumps(data, indent=2))

if __name__ == "__main__":
    main()
