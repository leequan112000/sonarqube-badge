#!/bin/bash
[ -z $SONAR_PROJECT ] && echo "SONAR_PROJECT env not found" && exit 1;
[ -z $SONAR_HOST_URL ] && echo "SONAR_HOST_URL env not found" && exit 1;
[ -z $SONAR_BADGE_TOKEN ] && echo "SONAR_BADGE_TOKEN env not found" && exit 1;

# remove trailing slash
if [[ "$SONAR_HOST_URL" =~ /$ ]]; then
  SONAR_HOST_URL=${SONAR_HOST_URL%?}
fi

# Default metrics if TARGET_METRICS is not set or is set to 'all'
DEFAULT_METRICS="alert_status,bugs,code_smells,coverage,duplicated_lines_density,ncloc,sqale_rating,reliability_rating,security_hotspots,security_rating,sqale_index,vulnerabilities"

# Use TARGET_METRICS if set, otherwise use DEFAULT_METRICS
METRICS=${TARGET_METRICS:-$DEFAULT_METRICS}
[[ "$METRICS" == "all" ]] && METRICS=$DEFAULT_METRICS

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
  for metric in ${METRICS//,/ }; do
    LABEL=$(getLabel $metric)
    LINK=$(getLink $metric)
    BADGE_URL="${SONAR_HOST_URL}/api/project_badges/measure?project=${SONAR_PROJECT}&metric=${metric}&token=${SONAR_BADGE_TOKEN}"
    LINK_URL="${SONAR_HOST_URL}${LINK}"
    echo "[![$LABEL](${BADGE_URL})](${LINK_URL})"
  done
}

generateLink() {
  for metric in ${METRICS//,/ }; do
    LINK=$(getLink $metric)
    if [[ ! -z $LINK ]]; then
      echo "${SONAR_HOST_URL}${LINK}"
    fi
  done
}

generateList() {
  for metric in ${METRICS//,/ }; do
    LABEL=$(getLabel $metric)
    if [[ ! -z $LABEL ]]; then
      echo "${SONAR_HOST_URL}/api/project_badges/measure?project=${SONAR_PROJECT}&metric=${metric}&token=${SONAR_BADGE_TOKEN}"
    fi
  done
}

case $1 in
  'markdown') generateMarkdown ;;
  'link') generateLink ;;
  'list') generateList ;;
esac