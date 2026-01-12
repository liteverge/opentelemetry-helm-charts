# Migration to Liteverge Dependencies - Complete! 🎉

## What Was Changed

All chart dependencies now use the Liteverge Helm repository instead of upstream OpenTelemetry.

### Files Updated:

1. **charts/opentelemetry-demo/Chart.yaml** ✅
   - Dependency: `opentelemetry-collector` 
   - Version: `0.134.0` → `0.143.0` (updated to your published version)
   - Repository: `open-telemetry` → `liteverge-opentelemetry`

2. **charts/opentelemetry-kube-stack/Chart.yaml** ✅
   - Dependency: `opentelemetry-operator`
   - Version: `0.99.0` → `0.102.0` (updated to your published version)
   - Repository: `open-telemetry` → `liteverge-opentelemetry`

3. **.github/workflows/release.yaml** ✅
   - Helm repo: `open-telemetry` → `liteverge-opentelemetry`

4. **.github/workflows/lint.yaml** ✅
   - Target branch: `main` → `liteverge-main`
   - Added both collector and operator repo references

5. **.github/workflows/demo-test.yaml** ✅
   - Helm repo: `opentelemetry-collector` → `liteverge-opentelemetry`

## Next Steps

### 1. Update Chart.lock Files

Run the provided script to update the lock files:

```bash
./update-dependencies.sh
```

Or manually:

```bash
# Add repositories
helm repo add liteverge-opentelemetry https://liteverge.github.io/opentelemetry-helm-charts
helm repo update

# Update dependencies
helm dependency update charts/opentelemetry-demo
helm dependency update charts/opentelemetry-kube-stack
```

### 2. Review Changes

Check that the Chart.lock files now reference Liteverge:

```bash
cat charts/opentelemetry-demo/Chart.lock | grep repository
cat charts/opentelemetry-kube-stack/Chart.lock | grep repository
```

Should show:
```
  repository: https://liteverge.github.io/opentelemetry-helm-charts
```

### 3. Bump Chart Versions

Since we're changing dependencies, we should bump the chart versions:

**charts/opentelemetry-demo/Chart.yaml:**
```yaml
version: 0.39.1  # was 0.39.0
```

**charts/opentelemetry-kube-stack/Chart.yaml:**
```yaml
version: 0.12.7  # was 0.12.6
```

### 4. Commit and Push

```bash
# Stage all changes
git add charts/opentelemetry-demo/Chart.yaml \
        charts/opentelemetry-demo/Chart.lock \
        charts/opentelemetry-kube-stack/Chart.yaml \
        charts/opentelemetry-kube-stack/Chart.lock \
        .github/workflows/

# Commit
git commit -m "chore: switch to liteverge repository for chart dependencies

- Update opentelemetry-demo to use liteverge collector v0.143.0
- Update opentelemetry-kube-stack to use liteverge operator v0.102.0
- Update all workflows to use liteverge repository
- Bump demo chart to v0.39.1
- Bump kube-stack chart to v0.12.7"

# Push
git push origin liteverge-main
```

### 5. Verify Release

After pushing, the release workflow will:
1. Package the updated demo and kube-stack charts
2. Create releases for v0.39.1 and v0.12.7
3. Update the Helm repository index
4. Push to GHCR

Verify at:
- **Releases**: https://github.com/liteverge/opentelemetry-helm-charts/releases
- **Helm Repo**: https://liteverge.github.io/opentelemetry-helm-charts
- **GHCR**: https://github.com/orgs/liteverge/packages

## Result

✅ **Your fork is now fully self-contained!**

All charts now use Liteverge-published dependencies:
- `opentelemetry-demo` → depends on Liteverge `opentelemetry-collector`
- `opentelemetry-kube-stack` → depends on Liteverge `opentelemetry-operator`

Users can install with:

```bash
helm repo add liteverge-opentelemetry https://liteverge.github.io/opentelemetry-helm-charts
helm repo update

# Install with Liteverge dependencies
helm install my-demo liteverge-opentelemetry/opentelemetry-demo
helm install my-stack liteverge-opentelemetry/opentelemetry-kube-stack
```

## Maintenance

Going forward:
1. When you update the collector chart, bump the demo chart version and its dependency
2. When you update the operator chart, bump the kube-stack chart version and its dependency
3. All builds will use your published charts - no more upstream dependencies!

## Rollback (if needed)

If you need to rollback to upstream dependencies:

```bash
git revert HEAD
git push origin liteverge-main
```

Then follow the instructions in `RELEASE_NOTES.md`.
