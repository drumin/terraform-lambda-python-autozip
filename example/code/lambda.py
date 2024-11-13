import requests

def main(event, context):
    print(requests.get("https://catfact.ninja/fact").json())
