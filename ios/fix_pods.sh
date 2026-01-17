#!/bin/bash

# Script de réparation rapide des pods iOS
# Usage: ./fix_pods.sh

echo "Reparation des CocoaPods..."

# Se placer dans le bon répertoire
cd "$(dirname "$0")"

# Nettoyage
echo "Suppression des pods existants..."
rm -rf Pods Podfile.lock 2>/dev/null
find . -name "Pods" -type d -exec rm -rf {} + 2>/dev/null

# Réinstallation
echo "Installation des pods..."
pod install

echo "Termine. Vous pouvez maintenant ouvrir Runner.xcworkspace"
