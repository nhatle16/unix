#!/bin/bash

# Function to get all VSZ (virtual memory size) values for a given user
get_user_vsz() {
    local username="$1"
    # Use 'ps' to list processes for the user and extract the VSZ column
    ps -u "$username" -o vsz | tail -n +2 | grep -E '[0-9]'
}

# Function to calculate the total VSZ usage
calculate_total_vsz() {
    local vsz_values=("$@")
    local total=0

    # Loop through VSZ values and sum them up
    for value in "${vsz_values[@]}"; do
        total=$((total + value))
    done

    echo "$total"
}

# Function to find the largest (peak) VSZ usage
calculate_peak_vsz() {
    local vsz_values=("$@")
    local peak=0

    # Loop through VSZ values to find the maximum
    for value in "${vsz_values[@]}"; do
        if ((value > peak)); then
            peak=$value
        fi
    done

    echo "$peak"
}

# Main script logic
main() {
    # Check if a username is provided
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <username>"
        exit 1
    fi

    local username="$1"

    # Get VSZ values for the user
    vsz_values=($(get_user_vsz "$username"))
    echo $vsz_values

    # If no VSZ values are found, return zero for total and peak
    if [[ ${#vsz_values[@]} -eq 0 ]]; then
        echo "$username: 0 0"
        exit 0
    fi

    # Calculate total and peak VSZ
    local total_vsz=$(calculate_total_vsz "${vsz_values[@]}")
    local peak_vsz=$(calculate_peak_vsz "${vsz_values[@]}")

    # Print the result in the required format
    echo "$username: $total_vsz $peak_vsz"
}

# Run the script
main "$@"
