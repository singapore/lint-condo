/* eslint-disable no-sync */

const fs = require('fs');
const chalk = require('chalk');
const yaml = require('js-yaml');
const logSymbols = require('log-symbols');
const spawn = require('child_process').spawn;
const pkg = require('/package.json');

const lintPackages = Object.keys(pkg.dependencies).concat(
  'markdownlint', // npm markdownlint-cli
  'yamllint', // pip
  'proselint', // pip
  'scss-lint' // gem
);

function run(command) {
  return new Promise(function(resolve) {
    logger.info(`\nRunning "${command}"`);
    const child = spawn('/bin/sh', ['-c', command], {stdio: 'inherit'});
    child.on('error', function(err) {
      logger.error(err);
      resolve(255); // eslint-disable-line no-magic-numbers
    });
    child.on('exit', function(code) {
      logger.info(`\nFinished "${command}" (code=${code})\n`);
      resolve(code);
    });
  });
}

/* eslint-disable no-console */
const logger = {
  error: function(msg) {
    console.error(chalk.bgRed(msg));
  },
  info: function(msg) {
    console.log(chalk.blue(msg));
  },
  pass: function(msg) {
    console.log(logSymbols.success, chalk.green(msg));
  },
  fail: function(msg) {
    console.log(logSymbols.error, chalk.red(msg));
  },
};
/* eslint-enable no-console */

let configFile = null;
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
const config = yaml.load(configFile);

let queue = Promise.resolve();
const statuses = {};
let exitCode = 0;

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
      let printedCommand = command;
      const firstWord = command.substr(0, command.indexOf(' '));
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
