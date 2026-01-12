#!/bin/bash
set -e

echo "🔄 Updating chart dependencies to use Liteverge repository..."

# Add the Liteverge repository
echo "📦 Adding helm repositories..."
helm repo add liteverge-opentelemetry https://liteverge.github.io/opentelemetry-helm-charts || true
helm repo add prometheus https://prometheus-community.github.io/helm-charts || true
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo add jaeger https://jaegertracing.github.io/helm-charts || true
helm repo add opensearch https://opensearch-project.github.io/helm-charts || true

echo "🔄 Updating helm repositories..."
helm repo update

echo ""
echo "📊 Updating opentelemetry-demo dependencies..."
helm dependency update charts/opentelemetry-demo

echo ""
echo "📊 Updating opentelemetry-kube-stack dependencies..."
helm dependency update charts/opentelemetry-kube-stack

echo ""
echo "✅ Dependencies updated successfully!"
echo ""
echo "Next steps:"
echo "  1. Review the Chart.lock changes"
echo "  2. Commit and push:"
echo "     git add charts/*/Chart.yaml charts/*/Chart.lock"
echo "     git commit -m 'chore: switch to liteverge repository for dependencies'"
echo "     git push origin liteverge-main"
