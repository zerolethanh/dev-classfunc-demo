#!/usr/bin/env bash
## DEVELOPER TODO: replace your PROJECT_ID and TOPIC
PROJECT_ID='...'
TOPIC='...'
RUNTIME='nodejs12'

## auto get all project's repos, format as ('repo1' 'repo2')
REPOS=($(gcloud source repos list --format="value(REPO_NAME)" --project=${PROJECT_ID} | tr '\r\n' ' '))

## step 1 : create topic (ONE TIME)
## uncomment to use
#gcloud pubsub topics create $TOPIC --project=$PROJECT_ID

## step 2: add topic to repo
for REPO in "${REPOS[@]}"; do
  echo $REPO
  gcloud source repos update "$REPO" \
    --add-topic=$TOPIC \
    --project=$PROJECT_ID \
    --service-account=$PROJECT_ID@appspot.gserviceaccount.com \
    --message-format=json
done

## step 3: deploy subscription function (ONE TIME)
## uncomment to use
#gcloud functions deploy slackOnCodePushed \
#  --runtime=${RUNTIME} \
#  --project=$PROJECT_ID \
#  --trigger-topic=$TOPIC \
#  --allow-unauthenticated
