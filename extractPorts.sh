#!/bin/zsh

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo -e "${RED}Usage: $0 <nmap_output_file>${NC}"
    exit 1
fi

FILE=$1

# Extract open ports and copy to clipboard
PORTS=$(grep -oP '\d+/open/tcp/\S+' "$FILE" | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')
echo $PORTS | xclip -selection clipboard

# Count the total number of open ports
TOTAL_PORTS=$(echo "$PORTS" | tr ',' '\n' | wc -l)


# Print the results with colors
echo -e "${CYAN}Open Ports:${NC} ${GREEN}$PORTS${NC}"
echo -e "${CYAN}Total Ports:${NC} ${YELLOW}$TOTAL_PORTS${NC}"

# Copy ports to clipboard
echo "$PORTS" | xclip -selection clipboard
echo -e "${GREEN}Ports have been copied to clipboard.${NC}"