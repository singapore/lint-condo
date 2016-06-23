/* eslint-disable no-sync */

var fs = require('fs');
var chalk = require('chalk');
var yaml = require('js-yaml');
var logSymbols = require('log-symbols');
var spawn = require('child_process').spawn;
var pkg = require('./package.json');

var lintPackages = Object.keys(pkg.dependencies).concat(
  'markdownlint', // npm markdownlint-cli
  'yamllint', // pip
  'proselint', // pip
  'scss-lint' // gem
);

/* eslint-disable no-console */
var logger = {
  error: function() {
    console.error(chalk.bgReg.apply(null, arguments));
  },
  info: function() {
    console.log(chalk.blue.apply(null, arguments));
  },
  pass: function() {
    console.log(logSymbols.success, chalk.green.apply(null, arguments));
  },
  fail: function() {
    console.log(logSymbols.error, chalk.red.apply(null, arguments));
  }
};
/* eslint-enable no-console */

var configFile = null;
try {
  configFile = fs.readFileSync('lint-condo.yaml', 'utf-8');
} catch (err1) {
  try {
    configFile = fs.readFileSync('.lint-condo.yaml', 'utf-8');
  } catch (err2) {
    logger.error('ERROR: Couldn\'t find a config file');
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
    logger.info('\nSummary:');
    Object.keys(statuses).forEach(function(command) {
      var printedCommand = command;
      var firstWord = command.substr(0, command.indexOf(' '));
      if (lintPackages.indexOf(firstWord) !== -1) {
        printedCommand = firstWord;
      }
      if (statuses[command] === 0) {
        logger.pass(printedCommand);
      } else {
        logger.fail(printedCommand);
      }
    });
    process.exit(exitCode);
  })
  .catch(function(err) {
    logger.error(err.stack);
    process.exit(1);
  });

function run(command) {
  return new Promise(function(resolve) {
    logger.info('\nRunning "%s"', command);
    var child = spawn('/bin/sh', ['-c', command], {stdio: 'inherit'});
    child.on('error', function(err) {
      logger.error(err);
      resolve(255); // eslint-disable-line no-magic-numbers
    });
    child.on('exit', function(code) {
      logger.info('\nFinished "%s" (code=%d)\n', command, code);
      resolve(code);
    });
  });
}
