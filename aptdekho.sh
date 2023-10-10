#!/bin/bash

# Define the menu options
OPTIONS=(
  "1." "Install Packages"
  "2." "Remove Packages"
  "3." "Update Packages"
  "4." "Check for Updates"
  "5." "Search Packages"
  "~" "Exit"
)

# Function to install packages
install_packages() {
  packages=$(whiptail --inputbox "Enter the packages to install (separated by spaces):" 10 60 --title "Install Packages" 3>&1 1>&2 2>&3)
  if [ $? -eq 0 ]; then
    for package in $packages; do
      if sudo apt install "^$package$" >/dev/null; then
        sudo apt install $package 
        whiptail --msgbox "Package '$package' installed successfully!" 10 60 --title "Install Packages"
      else
        whiptail --msgbox "Target not found: $package" 10 60 --title "Install Packages"
      fi
    done
  fi
}

# Function to remove packages
remove_packages() {
  packages=$(whiptail --inputbox "Enter the packages to remove (separated by spaces):" 10 60 --title "Remove Packages" 3>&1 1>&2 2>&3)
  if [ $? -eq 0 ]; then
    sudo apt remove $packages
    whiptail --msgbox "Packages removed successfully!" 10 60 --title "Remove Packages"
  fi
}

# Function to update packages
update_packages() {
  sudo apt upgrade 
  whiptail --msgbox "Packages updated successfully!" 10 60 --title "Update Packages"
}

# Function to check for updates
check_updates() {
  updates=$(sudo apt update)
  if [ -z "$updates" ]; then
    whiptail --msgbox "No updates available!" 10 60 --title "Check for Updates"
  else
    whiptail --msgbox "Updates available:\n\n$updates" 20 80 --title "Check for Updates"
  fi
}

# Function to search for packages
search_packages() {
  query=$(whiptail --inputbox "Enter the package name or keyword to search:" 10 60 --title "Search Packages" 3>&1 1>&2 2>&3)
  if [ $? -eq 0 ]; then
    if sudo apt search "$query" >/dev/null ; then
      results=$(sudo apt search "$query" | awk '!/Checking for conflicting packages/')
      if [ -z "$results" ]; then
        whiptail --msgbox "No packages found!" 10 60 --title "Search Packages"
      else
        whiptail --msgbox "Search results:\n\n$results" 20 80 --title "Search Packages"
      fi
    else
      whiptail --msgbox "Target not found: $query" 10 60 --title "Search Packages"
    fi
  fi
}

# Show the menu and execute selected option
while true; do
  CHOICE=$(whiptail --title "APT Package Manager" --menu "Choose an option:" 15 60 6 "${OPTIONS[@]}" 3>&1 1>&2 2>&3)
  case $CHOICE in
    "1.")
      install_packages
      ;;
    "2.")
      remove_packages
      ;;
    "3.")
      update_packages
      ;;
    "4.")
      check_updates
      ;;
    "5.")
      search_packages
      ;;
    "~")
      exit 0
      ;;
    *)
      whiptail --msgbox "Invalid option" 10 60 --title "Error"
      ;;
  esac
done
