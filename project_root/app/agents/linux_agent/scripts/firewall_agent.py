import subprocess
import logging
import time
import json
import os
from datetime import datetime

# Configuration file path
CONFIG_PATH = "/home/navarch/devsec/project_root/app/config/linux_config.json"
LOG_FILE = "/home/navarch/devsec/project_root/app/logs/linux_firewall_agent.log"

# Setup logging
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def load_policies(config_path):
    """Load firewall policies from a JSON configuration file."""
    if not os.path.exists(config_path):
        logging.error(f"Configuration file {config_path} does not exist.")
        return []
    with open(config_path, 'r') as file:
        try:
            policies = json.load(file)
            logging.info("Firewall policies loaded successfully.")
            return policies
        except json.JSONDecodeError as e:
            logging.error(f"Error decoding JSON: {e}")
            return []

def apply_firewall_rules(policies):
    """Apply a list of firewall rules."""
    for policy in policies:
        try:
            subprocess.run(policy, shell=True, check=True)
            logging.info(f"Successfully applied rule: {policy}")
        except subprocess.CalledProcessError as e:
            logging.error(f"Failed to apply rule: {policy} | Error: {e}")

def remove_firewall_rules(policies):
    """Remove a list of firewall rules."""
    for policy in policies:
        try:
            # Modify the rule to remove it
            remove_rule = policy.replace("-A", "-D")
            subprocess.run(remove_rule, shell=True, check=True)
            logging.info(f"Successfully removed rule: {remove_rule}")
        except subprocess.CalledProcessError as e:
            logging.error(f"Failed to remove rule: {remove_rule} | Error: {e}")

def monitor_traffic():
    """Monitor network traffic and log it."""
    try:
        # Run tcpdump in the background and log output
        with open("/home/navarch/devsec/project_root/app/logs/traffic.log", "a") as log_file:
            subprocess.run("tcpdump -i eth0 tcp -w -", shell=True, stdout=log_file)
    except Exception as e:
        logging.error(f"Error in monitoring traffic: {e}")

def refresh_policies(policies):
    """Refresh firewall policies by first removing old rules and applying new ones."""
    logging.info("Refreshing firewall policies.")
    remove_firewall_rules(policies)
    apply_firewall_rules(policies)

def main():
    logging.info("Starting Linux Firewall Agent.")
    policies = load_policies(CONFIG_PATH)
    if not policies:
        logging.warning("No policies to apply. Exiting.")
        return

    apply_firewall_rules(policies)
    
    # Start monitoring traffic in a separate thread or process if needed
    # For simplicity, we'll run it in the main thread here
    try:
        while True:
            # Placeholder for dynamic policy updates or other tasks
            time.sleep(60)  # Sleep for 1 minute
            # Example: Reload policies periodically
            new_policies = load_policies(CONFIG_PATH)
            if new_policies != policies:
                refresh_policies(new_policies)
                policies = new_policies
    except KeyboardInterrupt:
        logging.info("Shutting down Linux Firewall Agent.")
        remove_firewall_rules(policies)
    except Exception as e:
        logging.error(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()
