import os
import sys
import requests
import json

def get_alphavantage_data(params):
    api_key = os.environ.get('ALPHA_VANTAGE_API_KEY')
    if not api_key:
        print("Error: ALPHA_VANTAGE_API_KEY environment variable is not set.")
        sys.exit(1)
    
    base_url = "https://www.alphavantage.co/query"
    params['apikey'] = api_key
    
    try:
        response = requests.get(base_url, params=params)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from Alpha Vantage: {e}")
        sys.exit(1)
    except json.JSONDecodeError:
        print("Error: Failed to decode JSON from Alpha Vantage. Check if you have exceeded the API rate limit.")
        sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("Usage: python alphavantage_client.py <json_params>")
        print("Example: python alphavantage_client.py '{\"function\": \"TIME_SERIES_DAILY\", \"symbol\": \"IBM\"}'")
        sys.exit(1)
    
    try:
        params = json.loads(sys.argv[1])
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON params: {sys.argv[1]}")
        sys.exit(1)
            
    data = get_alphavantage_data(params)
    print(json.dumps(data, indent=2))

if __name__ == "__main__":
    main()
