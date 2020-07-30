VERSION=$(head -n 1 VERSION)
git checkout release -f 
git tag "${VERSION}"
git push origin "${VERSION}"