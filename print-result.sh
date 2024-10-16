#!/bin/bash

# Default metrics if TARGET_METRICS is not set or is set to 'all'
DEFAULT_METRICS="alert_status,bugs,code_smells,coverage,duplicated_lines_density,ncloc,sqale_rating,reliability_rating,security_hotspots,security_rating,sqale_index,vulnerabilities"

# Use TARGET_METRICS if set, otherwise use DEFAULT_METRICS
METRICS=${TARGET_METRICS:-$DEFAULT_METRICS}
[[ "$METRICS" == "all" ]] && METRICS=$DEFAULT_METRICS

getLabel() {
  case $1 in
    bugs) echo "Bugs" ;;
    code_smells) echo "Code Smells" ;;
    coverage) echo "Coverage" ;;
    duplicated_lines_density) echo "Duplicated Lines (%)" ;;
    ncloc) echo "Lines of Code" ;;
    sqale_rating) echo "Maintainability Rating" ;;
    alert_status) echo "Quality Gate Status" ;;
    reliability_rating) echo "Reliability Rating" ;;
    security_hotspots) echo "Security Hotspots" ;;
    security_rating) echo "Security Rating" ;;
    sqale_index) echo "Technical Debt" ;;
    vulnerabilities) echo "Vulnerabilities" ;;
    *) echo "$1" ;;
  esac
}

getLink() {
  case $1 in
    alert_status) echo "/dashboard?id=$SONAR_PROJECT" ;;
    *) echo "/component_measures?id=$SONAR_PROJECT&metric=$1" ;;
  esac
}

case $1 in
  'metrics') echo $METRICS ;;
  'label') getLabel $2 ;;
  'link') getLink $2 ;;
esac