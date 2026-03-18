import os
import sys
import requests
import json

def get_fred_data(endpoint, params=None):
    api_key = os.environ.get('FRED_API_KEY')
    if not api_key:
        print("Error: FRED_API_KEY environment variable is not set.")
        sys.exit(1)
    
    base_url = "https://api.stlouisfed.org/fred"
    url = f"{base_url}/{endpoint}"
    
    if params is None:
        params = {}
    params['api_key'] = api_key
    params['file_type'] = 'json'
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from FRED: {e}")
        # Try to print more context if it's a JSON error from FRED
        try:
            error_info = response.json()
            print(json.dumps(error_info, indent=2))
        except:
            pass
        sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("Usage: python fred_client.py <endpoint> [json_params]")
        print("Endpoints: series, series/observations, series/search, etc.")
        sys.exit(1)
    
    endpoint = sys.argv[1].strip("/")
    params = {}
    if len(sys.argv) > 2:
        try:
            params = json.loads(sys.argv[2])
        except json.JSONDecodeError:
            print(f"Error: Invalid JSON params: {sys.argv[2]}")
            sys.exit(1)
            
    data = get_fred_data(endpoint, params)
    # Output the result to stdout for Gemini CLI to read
    print(json.dumps(data, indent=2))

if __name__ == "__main__":
    main()
