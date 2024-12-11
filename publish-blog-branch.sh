hugo
sleep 2
git add public assets content resources
git commit -m "Add changes in public, assets, content, and resources folders after Hugo build"
git push origin main
git subtree split --prefix public -b blog-deploy
git push origin blog-deploy:blog --force
git branch -D blog-deploy