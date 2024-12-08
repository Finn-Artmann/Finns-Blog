git subtree split --prefix public -b blog-deploy
git push origin blog-deploy:blog --force
git branch -D blog-deploy