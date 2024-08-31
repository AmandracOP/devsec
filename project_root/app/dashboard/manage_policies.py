import requests

def apply_linux_policies():
    response = requests.post('http://linux-agent:5000/apply_rules')
    print(response.json())

def apply_windows_policies():
    response = requests.post('http://windows-agent:5000/apply_rules')
    print(response.json())
