/* eslint-disable no-sync */
/* eslint-disable no-console */

var fs = require('fs');
var spawn = require('child_process').spawn;
var yaml = require('js-yaml');

var configFile = null;
try {
  configFile = fs.readFileSync('lint-condo.yaml', 'utf-8');
} catch (err1) {
  try {
    configFile = fs.readFileSync('.lint-condo.yaml', 'utf-8');
  } catch (err2) {
    console.error('ERROR: Couldn\'t find a config file');
    process.exit(1);
  }
}
var config = yaml.load(configFile);

var queue = Promise.resolve();
var statuses = {};
var exitCode = 0;

config.linters.forEach(function(linter) {
  queue = queue.then(function() {
    return run(linter).then(function(code) {
      statuses[linter] = code;
      exitCode = Math.max(exitCode, code);
    });
  });
});

queue
  .then(function() {
    console.log('\nSummary:');
    Object.keys(statuses).forEach(function(command) {
      console.log('"%s" exited with code %d', command, statuses[command]);
    });
    process.exit(exitCode);
  })
  .catch(function(err) {
    console.error(err.stack);
    process.exit(1);
  });

function run(command) {
  return new Promise(function(resolve) {
    console.log('\nRunning "%s"', command);
    var child = spawn('/bin/sh', ['-c', command], {
      stdio: ['ignore', 1, 2]
    });
    child.on('error', function(err) {
      console.error(err);
      resolve(255); // eslint-disable-line no-magic-numbers
    });
    child.on('exit', function(code) {
      console.log('\nFinished "%s" (code=%d)\n', command, code);
      resolve(code);
    });
  });
}
