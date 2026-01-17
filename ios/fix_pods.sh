#!/bin/bash

# Script de réparation rapide des pods iOS
# Usage: ./fix_pods.sh

echo "🔧 Réparation des CocoaPods..."

# Se placer dans le bon répertoire
cd "$(dirname "$0")"

# Nettoyage
echo "📦 Suppression des pods existants..."
rm -rf Pods Podfile.lock

# Réinstallation
echo "⬇️  Installation des pods..."
pod install

echo "✅ Terminé ! Vous pouvez maintenant ouvrir Runner.xcworkspace"
