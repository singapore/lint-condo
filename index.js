/* eslint-disable no-sync */
/* eslint-disable no-console */

var fs = require('fs');
var yaml = require('js-yaml');
var logSymbols = require('log-symbols');
var lintDependencies = require('/usr/src/lint-condo/package.json').dependencies;
var spawn = require('child_pty').spawn;

var lintPackages = Object.keys(lintDependencies);
lintPackages.push('markdownlint'); // npm markdownlint-cli
lintPackages.push('yamllint'); // pip
lintPackages.push('proselint'); // pip
lintPackages.push('scss-lint'); // gem
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
      var printedCommand = command;
      var firstWord = command.substr(0, command.indexOf(' '));
      if (lintPackages.indexOf(firstWord) !== -1) {
        printedCommand = firstWord;
      }
      if (statuses[command] === 0) {
        console.log(logSymbols.success, printedCommand);
      } else {
        console.log(logSymbols.error, printedCommand);
      }
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
    var child = spawn('/bin/sh', ['-c', command]);
    child.stdout.pipe(process.stdout);
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
