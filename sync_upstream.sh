#!/bin/bash
# sync_upstream.sh

echo "========================================="
echo "Starting sync process..."
echo "========================================="

# 获取所有远程仓库的最新代码
echo ""
echo "📥 Fetching from upstream (Koenkk)..."
git fetch upstream

echo ""
echo "📥 Fetching from fangzheli..."
git fetch fangzheli

echo ""
echo "📥 Fetching from origin..."
git fetch origin

# 更新 master 分支（保持与 Koenkk 同步）
echo ""
echo "========================================="
echo "🔄 Updating master branch..."
echo "========================================="
git checkout master
git merge upstream/master
if [ $? -eq 0 ]; then
    git push origin master
    echo "✅ Master branch updated successfully!"
else
    echo "❌ Failed to merge master branch. Please resolve conflicts manually."
    exit 1
fi

# 更新你的 blz_z2m 分支
echo ""
echo "========================================="
echo "🔄 Updating blz_z2m branch..."
echo "========================================="
git checkout blz_z2m

# 先合并 Koenkk 的最新代码
echo "Merging upstream/master..."
git merge upstream/master
if [ $? -ne 0 ]; then
    echo "❌ Conflicts detected when merging upstream/master"
    echo "Please resolve conflicts and run: git merge --continue"
    exit 1
fi

# 再合并 fangzheli 的 blz 功能
echo "Merging fangzheli/feat/blz-local-dev..."
git merge fangzheli/feat/blz-local-dev
if [ $? -ne 0 ]; then
    echo "❌ Conflicts detected when merging fangzheli/feat/blz-local-dev"
    echo "Please resolve conflicts and run: git merge --continue"
    exit 1
fi

# 推送到远程
git push origin blz_z2m
if [ $? -eq 0 ]; then
    echo "✅ blz_z2m branch updated successfully!"
else
    echo "❌ Failed to push blz_z2m branch"
    exit 1
fi

echo ""
echo "========================================="
echo "✅ Sync completed successfully!"
echo "========================================="
echo ""
echo "📊 Branch status:"
git branch -vv | grep -E "(master|blz_z2m)"

