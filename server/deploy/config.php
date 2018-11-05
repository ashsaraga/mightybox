<?php
// Secret token for GitHub access (set server-side in /etc/environment)
$token = getenv('SECRET_TOKEN');
define("TOKEN", $token);
// Repo SSH clone link (retrieved by droplet.rb)
$repo = getenv("GITHUB_REPO");
define("REMOTE_REPOSITORY", $repo);
// Master branch git ref path
define("BRANCH", "refs/heads/master");
// Master branch server-side directory
define("DIR", "/var/www/wordpress/");
// Staging branch git ref path
define("STAGING_BRANCH", "refs/heads/staging");
// Staging branch server-side directory
define("STAGING_DIR", "/var/www/staging/");
// Log file server-side location
define("LOGFILE", "deploy.log");
// Git server-side directory
define("GIT", "/usr/bin/git");
// Optional action after pull
define("AFTER_PULL", "");
