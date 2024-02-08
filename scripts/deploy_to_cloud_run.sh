#!/bin/bash

GCP_PROJECT_ID=$(gcloud config get-value project)
RUN_IMAGE_NAME="hey-yo-http"

# Build and deploy the container image to Cloud Run
function build_image() {
  gcloud builds submit --tag "asia.gcr.io/$GCP_PROJECT_ID/$RUN_IMAGE_NAME" .
}

# Deploy 10 Cloud Run Services on specific region from the container image
function deploy_ten_services() {
  local RUN_SERVICE_NAME=$1
  local RUN_SERVICE_REGION=$2
  local RUN_SERVICE_CPU=$3
  local RUN_SERVICE_MEM=$4

  for i in $(seq 0 9); do
    deploy_service "$RUN_IMAGE_NAME-$i" "$RUN_SERVICE_REGION" "$RUN_SERVICE_CPU" "$RUN_SERVICE_MEM"
  done
}

# Deploy a Cloud Run Services on specific region from the container image
function deploy_service() {
  local RUN_SERVICE_NAME=$1
  local RUN_SERVICE_REGION=$2
  local RUN_SERVICE_CPU=$3
  local RUN_SERVICE_MEM=$4

  gcloud run deploy "$RUN_SERVICE_NAME" \
    --image "asia.gcr.io/$GCP_PROJECT_ID/$RUN_IMAGE_NAME:latest" \
    --region "$RUN_SERVICE_REGION" --no-allow-unauthenticated --platform managed \
    --cpu "$RUN_SERVICE_CPU" --memory "$RUN_SERVICE_MEM" \
    --update-env-vars "BE_QUIET=1" \
    --execution-environment gen2 --min-instances 1 --max-instances 1
}

main() {
  build_image

  for region in asia-northeast1 asia-northeast2; do
    deploy_ten_services "$RUN_IMAGE_NAME" "$region" "1" "512Mi"
    deploy_service "$RUN_IMAGE_NAME-fat" "$region" "4" "16Gi"
  done
}

main
