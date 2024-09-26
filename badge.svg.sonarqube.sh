#!/bin/bash

# color map
lightgrey='9f9f9f';
blue='007ec6';
brightgreen='4c1';
green='97ca00';
yellowgreen='fe7d37';
yellow='e05d44';
orange='dfb317';
red='a4a61d';

# default values
COLOR='lightgrey';
STYLE='flat-square';

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

getRatingColor() {
  [[ "${1}" -le "A" ]] && COLOR='brightgreen';
  [[ "${1}" -lt "B" ]] && COLOR='green';
  [[ "${1}" -lt "C" ]] && COLOR='yellow';
  [[ "${1}" -lt "D" ]] && COLOR='orange';
  [[ "${1}" -lt "E" ]] && COLOR='red';
}
getPercentageAscColor() {
  ARG=$(echo $1 | sed 's/%$//')
  # avoid floating point compare
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -ge "8000" ]] && COLOR='red';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "8000" ]] && COLOR='orange';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "6000" ]] && COLOR='yellow';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "4000" ]] && COLOR='yellowgreen';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "2000" ]] && COLOR='green';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "1000" ]] && COLOR='brightgreen';
}
getPercentageDescColor() {
  ARG=$(echo $1 | sed 's/%$//')
  # avoid floating point compare
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -le "10000" ]] && COLOR='brightgreen';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "9000" ]] && COLOR='green';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "8000" ]] && COLOR='yellowgreen';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "7000" ]] && COLOR='yellow';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "5000" ]] && COLOR='orange';
  [[ "$(awk "BEGIN {print ${ARG}*100}")" -lt "3000" ]] && COLOR='red';
}
getNumberAscColor() {
  [[ "${1}" -eq "0" ]] && COLOR='brightgreen' || COLOR='red';
}
getStatusColor() {
  [[ "${1}" == "passed" ]] && COLOR='brightgreen' || COLOR='red';
}
setColor() {
  [ $1 == "bugs" ] && getNumberAscColor $2
  [ $1 == "code_smells" ] && getNumberAscColor $2
  [ $1 == "coverage" ] && getPercentageDescColor $2
  [ $1 == "duplicated_lines_density" ] && getPercentageAscColor $2
  [ $1 == "ncloc" ] && COLOR='blue'
  [ $1 == "sqale_rating" ] && getRatingColor $2
  [ $1 == "alert_status" ] && getStatusColor $2
  [ $1 == "reliability_rating" ] && getRatingColor $2
  [ $1 == "security_rating" ] && getRatingColor $2
  [ $1 == "sqale_index" ] && COLOR='blue'
  [ $1 == "vulnerabilities" ] && getNumberAscColor $2
}

# tested by sonarqube v7.9.2
generateSVGFromSonarqube() {
  METRIC='coverage'
  [ ! -z $1 ] && METRIC="$1"
  curl -sS "$SONAR_HOST_URL/api/project_badges/measure?project=$SONAR_PROJECT&metric=$METRIC&token=$SONAR_TOKEN" -o "$TARGET_DIRECTORY/${METRIC}.sonarqube.svg"
}

generateSVGFromShieldsIO() {
  METRIC='coverage'
  [ ! -z $1 ] && METRIC="$1"
  LABEL=$(getLabel $METRIC | sed 's/ /%20/g')
  VALUE=$(cat $TARGET_DIRECTORY/${METRIC}.sonarqube.svg | grep -Eo '[A-E0-9a-z]+.?[0-9]*[%a-z]?<\/text>' | tail -n 1 | sed 's/<\/text>//');
  COLOR='lightgrey';
  if [ -z $VALUE ] || [ $VALUE == 'found' ]; then # "found" in "not found"
    VALUE='unknown'
  else
    setColor $METRIC $VALUE
  fi

  # echo "($METRIC) ${LABEL}: $VALUE ($COLOR)"

  MESSAGE=$(echo "$VALUE" | sed 's/%$/%25/')
  curl -sS -o "$TARGET_DIRECTORY/${METRIC}.svg" "https://img.shields.io/badge/${LABEL}-$MESSAGE-$COLOR?style=$STYLE"
}

[[ -z $SONAR_PROJECT && -f "$(pwd)/sonar-project.properties" ]] && SONAR_PROJECT=$(grep -E "^sonar.projectKey" $(pwd)/sonar-project.properties | cut -c 18-)
[[ -z $SONAR_HOST_URL && -f "$(pwd)/sonar-project.properties" ]] && SONAR_HOST_URL=$(grep -E "^sonar.host.url" $(pwd)/sonar-project.properties | cut -c 16-)
[[ -z $SONAR_TOKEN && -f "$(pwd)/sonar-project.properties" ]] && SONAR_TOKEN=$(grep -E "^sonar.token" $(pwd)/sonar-project.properties | cut -c 13-)
[ -z $SONAR_TOKEN ] && echo "SONAR_TOKEN env not found" && exit 1;
[ -z $SONAR_PROJECT ] && echo "SONAR_PROJECT env not found" && exit 1;
[ -z $SONAR_HOST_URL ] && echo "SONAR_HOST_URL env not found" && exit 1;
[ -z $TARGET_DIRECTORY ] && echo "TARGET_DIRECTORY env not found" && exit 1;
[ -z $TARGET_SVG_FROM ] && TARGET_SVG_FROM='shields.io';

if [[ "$SONAR_HOST_URL" =~ /$ ]]; then
  SONAR_HOST_URL=${SONAR_HOST_URL%?}
fi
if [[ -z $TARGET_METRICS ]] || [[ $TARGET_METRICS == "all" ]]; then
  TARGET_METRICS='bugs,code_smells,coverage,duplicated_lines_density,ncloc,sqale_rating,alert_status,reliability_rating,security_hotspots,security_rating,sqale_index,vulnerabilities'
fi
[ ! -d $TARGET_DIRECTORY ] && mkdir $TARGET_DIRECTORY;

# specified badge token
if [[ ! -z $SONAR_PROJECT_BADGE_TOKEN ]]; then
  SONAR_TOKEN=$SONAR_PROJECT_BADGE_TOKEN
# analysis token
elif [[ $SONAR_TOKEN =~ ^sqa_ ]]; then
  echo "analysis token is not supported"
  exit 1;
# user token
elif [[ $SONAR_TOKEN =~ ^squ_ ]]; then
  RESPONSE=$(curl -sS -u ${SONAR_TOKEN}: "$SONAR_HOST_URL/api/project_badges/token?project=$SONAR_PROJECT")
  SONAR_TOKEN=$(echo $RESPONSE | cut -d'"' -f4)
# badge token
elif [[ ! $SONAR_TOKEN =~ ^sqb_ ]]; then
  echo "Cannot find badge token"
  exit 1;
fi

for METRIC in $(echo $TARGET_METRICS | sed "s/,/ /g"); do
  LABEL=$(getLabel $METRIC)
  if [[ ! -z $LABEL ]]; then
    generateSVGFromSonarqube $METRIC

    if [[ $TARGET_SVG_FROM == 'shields.io' ]]; then
      generateSVGFromShieldsIO $METRIC
      rm $TARGET_DIRECTORY/${METRIC}.sonarqube.svg
    else
      mv $TARGET_DIRECTORY/${METRIC}.sonarqube.svg $TARGET_DIRECTORY/${METRIC}.svg
    fi
  fi
done
