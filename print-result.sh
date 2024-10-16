#!/bin/bash

[[ -z $SONAR_PROJECT && -f "$(pwd)/sonar-project.properties" ]] && SONAR_PROJECT=$(grep -E "^sonar.projectKey" $(pwd)/sonar-project.properties | cut -c 18-)
[[ -z $SONAR_HOST_URL && -f "$(pwd)/sonar-project.properties" ]] && SONAR_HOST_URL=$(grep -E "^sonar.host.url" $(pwd)/sonar-project.properties | cut -c 16-)
[ -z $SONAR_PROJECT ] && echo "SONAR_PROJECT env not found" && exit 1;
[ -z $SONAR_HOST_URL ] && echo "SONAR_HOST_URL env not found" && exit 1;
[ -z $SONAR_TOKEN ] && echo "SONAR_TOKEN env not found" && exit 1;

# remove trailing slash
if [[ "$SONAR_HOST_URL" =~ /$ ]]; then
  SONAR_HOST_URL=${SONAR_HOST_URL%?}
fi

# custom label
getLabel() {
  bugs='Bugs'
  code_smells='Code Smells'
  coverage='Coverage'
  duplicated_lines_density='Duplicated Lines (%)'
  ncloc='Lines of Code'
  sqale_rating='Maintainability Rating'
  alert_status='Quality Gate Status'
  reliability_rating='Reliability Rating'
  security_hotspots='Security Hotspots'
  security_rating='Security Rating'
  sqale_index='Technical Debt'
  vulnerabilities='Vulnerabilities'

  echo "${!1}"
}

# sonarqube link
getLink() {
  bugs="/component_measures?id=$SONAR_PROJECT&metric=bugs"
  code_smells="/component_measures?id=$SONAR_PROJECT&metric=code_smells"
  coverage="/component_measures?id=$SONAR_PROJECT&metric=coverage"
  duplicated_lines_density="/component_measures?id=$SONAR_PROJECT&metric=duplicated_lines_density"
  ncloc="/component_measures?id=$SONAR_PROJECT&metric=ncloc"
  sqale_rating="/component_measures?id=$SONAR_PROJECT&metric=sqale_rating"
  alert_status="/dashboard?id=$SONAR_PROJECT"
  reliability_rating="/component_measures?id=$SONAR_PROJECT&metric=reliability_rating"
  security_hotspots="/component_measures?id=$SONAR_PROJECT&metric=security_hotspots"
  security_rating="/component_measures?id=$SONAR_PROJECT&metric=security_rating"
  sqale_index="/component_measures?id=$SONAR_PROJECT&metric=sqale_index"
  vulnerabilities="/component_measures?id=$SONAR_PROJECT&metric=vulnerabilities"

  echo "${!1}"
}

generateMarkdown() {
  local metrics="alert_status,bugs,code_smells,coverage,duplicated_lines_density,ncloc,sqale_rating,reliability_rating,security_hotspots,security_rating,sqale_index,vulnerabilities"
  
  for metric in ${metrics//,/ }; do
    LABEL=$(getLabel $metric)
    LINK=$(getLink $metric)
    BADGE_URL="${SONAR_HOST_URL}/api/project_badges/measure?project=${SONAR_PROJECT}&metric=${metric}&token=${SONAR_TOKEN}"
    LINK_URL="${SONAR_HOST_URL}${LINK}"
    echo "[![$LABEL](${BADGE_URL})](${LINK_URL})"
  done
}

generateLink() {
  local metrics="alert_status,bugs,code_smells,coverage,duplicated_lines_density,ncloc,sqale_rating,reliability_rating,security_hotspots,security_rating,sqale_index,vulnerabilities"
  
  for metric in ${metrics//,/ }; do
    LINK=$(getLink $metric)
    if [[ ! -z $LINK ]]; then
      echo "${SONAR_HOST_URL}${LINK}"
    fi
  done
}

generateList() {
  local metrics="alert_status,bugs,code_smells,coverage,duplicated_lines_density,ncloc,sqale_rating,reliability_rating,security_hotspots,security_rating,sqale_index,vulnerabilities"
  
  for metric in ${metrics//,/ }; do
    LABEL=$(getLabel $metric)
    if [[ ! -z $LABEL ]]; then
      echo "${SONAR_HOST_URL}/api/project_badges/measure?project=${SONAR_PROJECT}&metric=${metric}&token=${SONAR_TOKEN}"
    fi
  done
}

case $1 in
  'markdown') generateMarkdown ;;
  'link') generateLink ;;
  'list') generateList ;;
esac