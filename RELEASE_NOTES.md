# Release Notes - Initial Liteverge Fork Setup

## Release Workflow Configuration

The release workflow is configured with `skip_existing: true` to handle cases where:
- Chart versions haven't changed since the last release
- Releases already exist from previous attempts
- You're re-running the workflow after a partial failure

This ensures the workflow is idempotent and won't fail if releases already exist.

## Important Note About Dependencies

For the **first release**, the following charts still depend on the upstream OpenTelemetry repository:

- `opentelemetry-demo` → depends on `opentelemetry-collector` from upstream
- `opentelemetry-kube-stack` → depends on `opentelemetry-operator` from upstream

This is intentional and necessary because:
1. Your Liteverge Helm repository doesn't exist yet until the first successful release
2. We need the dependencies to build the charts

## After First Successful Release

Once your charts are published to `https://liteverge.github.io/opentelemetry-helm-charts`, you should:

### Step 1: Update Chart Dependencies

**charts/opentelemetry-demo/Chart.yaml:**
```yaml
dependencies:
  - name: opentelemetry-collector
    version: 0.143.0  # or your released version
    repository: https://liteverge.github.io/opentelemetry-helm-charts
    condition: opentelemetry-collector.enabled
```

**charts/opentelemetry-kube-stack/Chart.yaml:**
```yaml
dependencies:
  - name: opentelemetry-operator
    repository: https://liteverge.github.io/opentelemetry-helm-charts
    version: 0.102.0  # or your released version
    condition: opentelemetry-operator.enabled
```

### Step 2: Update Release Workflow

**.github/workflows/release.yaml:**
```yaml
      - name: Add dependent repositories
        run: |
          helm repo add liteverge-opentelemetry https://liteverge.github.io/opentelemetry-helm-charts
          helm repo add prometheus https://prometheus-community.github.io/helm-charts
          helm repo add grafana https://grafana.github.io/helm-charts
          helm repo add jaeger https://jaegertracing.github.io/helm-charts
          helm repo add opensearch https://opensearch-project.github.io/helm-charts
```

### Step 3: Rebuild Dependencies and Release

```bash
# Update the Chart.lock files
helm dependency update charts/opentelemetry-demo
helm dependency update charts/opentelemetry-kube-stack

# Commit and push
git add charts/opentelemetry-demo/Chart.yaml charts/opentelemetry-demo/Chart.lock
git add charts/opentelemetry-kube-stack/Chart.yaml charts/opentelemetry-kube-stack/Chart.lock
git add .github/workflows/release.yaml
git commit -m "chore: switch to liteverge repository for chart dependencies"
git push origin liteverge-main
```

## Current Configuration

For now, the repository is configured to:
1. ✅ Build and publish all standalone charts (collector, operator, ebpf, etc.)
2. ✅ Use upstream dependencies for demo and kube-stack charts
3. ✅ Publish to GitHub Pages at `https://liteverge.github.io/opentelemetry-helm-charts`
4. ✅ Publish to GHCR at `ghcr.io/liteverge/opentelemetry-helm-charts`

This hybrid approach allows your first release to succeed while you establish your own Helm repository.

## Workflow

1. **First Release** (Current State):
   - All charts use current configuration
   - Demo and kube-stack depend on upstream OpenTelemetry charts
   - Your charts get published successfully

2. **After First Release**:
   - Update dependencies to point to your repository
   - Everything becomes self-contained within Liteverge

3. **Ongoing**:
   - All future releases use only Liteverge repositories
   - Sync with upstream as needed
