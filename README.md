# LiteLLM Cloud Run Deployment

Deploys [LiteLLM](https://github.com/BerriAI/litellm) proxy v1.83.0-stable to Google Cloud Run via Cloud Build.

## Prerequisites

1. A GCP project with these APIs enabled:
   - Cloud Build
   - Cloud Run
   - Artifact Registry
   - Secret Manager

2. An Artifact Registry repo:
   ```bash
   gcloud artifacts repositories create litellm-deploy \
     --repository-format=docker \
     --location=us-central1
   ```

3. Existing secrets in Secret Manager (already created):
   - `litellm-master-key`
   - `litellm-database-url`
   - `litellm-salt-key`
   - `litellm-config`
   - `litellm-monitor-database-url`

4. Give Cloud Build's service account access to Secret Manager:
   ```bash
   PROJECT_NUMBER=$(gcloud projects describe YOUR_PROJECT --format='value(projectNumber)')
   gcloud projects add-iam-policy-binding YOUR_PROJECT \
     --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"
   ```

## Deploy

```bash
gcloud builds submit --config=cloudbuild.yaml
```

## Configuration

Edit `litellm_config.yaml` to add/remove models. The config is baked into the image at build time.

Secrets pulled from Secret Manager at deploy time:
- `litellm-master-key` → `LITELLM_MASTER_KEY`
- `litellm-database-url` → `DATABASE_URL`
- `litellm-salt-key` → `LITELLM_SALT_KEY`

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | Builds on the official LiteLLM image, copies config |
| `cloudbuild.yaml` | Cloud Build pipeline: build → push → deploy to Cloud Run |
| `litellm_config.yaml` | LiteLLM proxy model configuration |
