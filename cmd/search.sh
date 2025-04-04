# manage cx commands
function cx__search() {
   
    # Check if the alias is provided
    if [[ -n $alias ]]; then 
        case $alias in
            # User wants help about the search command
            "--help") 
                show_help_search
                return 0  # Exit the function after showing help
                ;;  
            *) 
                # Proceed with validating the keyword
                validate_keyword "$alias"
                local validation_result=$?

                # If validation fails, return without searching
                if [[ $validation_result -ne 0 ]]; then
                    return 1
                fi

                # Proceed to search for the alias if validation is successful
                search_by_keyword $alias
                ;;
        esac
    else
        echo "Error: No keyword provided. Use 'cx search --help' for usage information."
        return 1
    fi
}

# Function to search for aliases based on a keyword
function search_by_keyword() {
    
    
    if [[ -z "$alias" ]]; then
        echo "Please provide a keyword to search for aliases."
        return 1
    fi

    # Search in the CSV file for aliases matching the keyword
    local results
    
    results=$(grep -i "${alias}" "$csv_file_path" | awk -F "," '{print "Alias: " $2 ", Path: " $3}')

    if [[ -z "$results" ]]; then
        echo "No aliases found matching the keyword: '$alias'."
    else
        echo -e "$results"
    fi
}

# Function to validate the keyword
function validate_keyword() {
    

    # Check if the keyword is empty
    if [[ -z "$alias" ]]; then
        echo "Error: The keyword cannot be empty."
        return 1
    fi

    # Check if the keyword is alphanumeric
    if ! [[ "$alias" =~ ^[a-zA-Z0-9]+$ ]]; then
        echo "Error: The keyword must be alphanumeric."
        return 1
    fi

    # Check if the keyword starts with a digit
    if [[ "$alias" =~ ^[0-9] ]]; then
        echo "Error: The keyword must not start with a digit."
        return 1
    fi

    # Check if the keyword contains a comma
    if [[ "$alias" == *,* ]]; then
        echo "Error: The keyword must not contain a comma."
        return 1
    fi

    # If all checks pass, return 0
    return 0
}

function show_help_search () {
    echo ""
    echo "NAME: Search by keyword"
    echo -e "\t cx search <keyword> - search for a shortcut by keyword"
    echo ""
    echo "DESCRIPTION:"
    echo -e "\t Use this command to find a shortcut based on the provided keyword."
    echo ""
    echo "USAGE:"
    echo -e "\t cx search [keyword]"
    echo ""
    echo "EXAMPLES:"
    echo -e "\t cx search doc     # Searches for shortcuts containing 'doc'"
    echo -e "\t cx search project # Searches for shortcuts related to 'project'"
    echo ""
}