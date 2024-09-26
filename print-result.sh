#!/bin/bash

[[ -z $SONAR_PROJECT && -f "$(pwd)/sonar-project.properties" ]] && SONAR_PROJECT=$(grep -E "^sonar.projectKey" $(pwd)/sonar-project.properties | cut -c 18-)
[[ -z $SONAR_HOST_URL && -f "$(pwd)/sonar-project.properties" ]] && SONAR_HOST_URL=$(grep -E "^sonar.host.url" $(pwd)/sonar-project.properties | cut -c 16-)
[ -z $SONAR_PROJECT ] && echo "SONAR_PROJECT env not found" && exit 1;
[ -z $SONAR_HOST_URL ] && echo "SONAR_HOST_URL env not found" && exit 1;
[ -z $TARGET_DIRECTORY ] && echo "TARGET_DIRECTORY env not found" && exit 1;

# remove trailing slash
if [[ "$SONAR_HOST_URL" =~ /$ ]]; then
  SONAR_HOST_URL=${SONAR_HOST_URL%?}
fi

# custom label
getLabel() {
  bugs='bugs'; # Number of bug issues. (number)
  code_smells='code smells'; # Total count of Code Smell issues. (number)
  coverage='coverage'; # Coverage (percentage)
  duplicated_lines_density='duplicated lines'; # duplicated_lines / lines * 100 (percentage)
  ncloc='lines of code'; # Lines of code (number k,m suffix)
  sqale_rating='maintainability'; # Maintainability Rating
  alert_status='quality gate'; # Quality Gate Status
  reliability_rating='reliability'; # Reliability Rating (A-E)
  security_hotspots='security hotspots' # Security Hotspots. (number)
  security_rating='security'; # Security Rating (A-E)
  sqale_index='technical debt'; # Technical Debt
  vulnerabilities='vulnerabilities'; # Number of vulnerability issues. (number)

  echo "${!1}"
}

# sonarqube link
getLink() {
  bugs="/component_measures?id=$SONAR_PROJECT&metric=bugs"; # Number of bug issues. (number)
  code_smells="/component_measures?id=$SONAR_PROJECT&metric=code_smells"; # Total count of Code Smell issues. (number)
  coverage="/component_measures?id=$SONAR_PROJECT&metric=coverage"; # Coverage (percentage)
  duplicated_lines_density="/component_measures?id=$SONAR_PROJECT&metric=duplicated_lines_density"; # duplicated_lines / lines * 100 (percentage)
  ncloc="/component_measures?id=$SONAR_PROJECT&metric=ncloc"; # Lines of code (number k,m suffix)
  sqale_rating="/component_measures?id=$SONAR_PROJECT&metric=sqale_rating"; # Maintainability Rating
  alert_status="/dashboard?id=$SONAR_PROJECT"; # Quality Gate Status
  reliability_rating="/component_measures?id=$SONAR_PROJECT&metric=reliability_rating"; # Reliability Rating (A-E)
  security_hotspots="/component_measures?id=$SONAR_PROJECT&metric=security_hotspots"; # Security Hotspots. (number)
  security_rating="/component_measures?id=$SONAR_PROJECT&metric=security_rating"; # Security Rating (A-E)
  sqale_index="/component_measures?id=$SONAR_PROJECT&metric=sqale_index"; # Technical Debt
  vulnerabilities="/component_measures?id=$SONAR_PROJECT&metric=vulnerabilities"; # Number of vulnerability issues. (number)

  echo "${!1}"
}

generateMarkdown() {
  for f in $TARGET_DIRECTORY/*.svg; do
    METRIC=$(basename $f .svg)
    LABEL=$(getLabel $METRIC 2>/dev/null)
    LINK=$(getLink $METRIC 2>/dev/null)
    if [[ ! -z $LABEL ]]; then
      echo "[![$LABEL](${TARGET_DIRECTORY}/${METRIC}.svg)](http${SONAR_HOST_URL:4}${LINK})"
    fi
  done
}

generateLink() {
  for f in $TARGET_DIRECTORY/*.svg; do
    METRIC=$(basename $f .svg)
    LINK=$(getLink $METRIC 2>/dev/null)
    if [[ ! -z $LINK ]]; then
      echo $LINK
    fi
  done
}

generateList() {
  for f in $TARGET_DIRECTORY/*.svg; do
    METRIC=$(basename $f .svg)
    LABEL=$(getLabel $METRIC 2>/dev/null)
    if [[ ! -z $LABEL ]]; then
      echo $f
    fi
  done
}

case $1 in
  'markdown') generateMarkdown ;;
  'link') generateLink ;;
  'list') generateList ;;
esac
