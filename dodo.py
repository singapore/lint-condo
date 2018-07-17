
from doit.tools import run_once
from os.path import abspath

DOIT_CONFIG = {
    'backend': 'sqlite3',
    'verbosity': 2,
    'default_tasks': ['build', 'test']
}

def task_build():
  return {
    'actions': ['docker build -t singapore/lint-condo .']
  }

def make_test(name, target, cmd=''):
  return {
    'name': name,
    'actions': ['docker run -v {target}:/src/ -e "FORCE_COLOR=true" singapore/lint-condo {cmd}'.format(target=target, cmd= cmd)]
  }

def task_test():
  yield make_test('self', abspath('.'))

def task_hadolint():
  rm_repo = 'rm -Rf hadolint/repo'
  yield {
    'name': 'repo',
    'actions': [
      rm_repo,
      'mkdir -p hadolint/repo',
      'cd hadolint/repo && curl -L https://github.com/lukasmartinelli/hadolint/archive/v1.0.tar.gz | tar xz --strip-components=1'
    ],
    'targets': ['hadolint/repo'],
    'uptodate': [True],
    'clean': [rm_repo]
  }

  rm_bin = 'rm -Rf hadolint/bin'
  yield {
    'name': 'build',
    'task_dep': ['hadolint:repo'],
    'actions': [
      rm_bin,
      'mkdir -p hadolint/bin',
      'docker run -v {target}:/hadolint/ mitchty/alpine-ghc:7.10 bash /hadolint/build.sh'.format(target=abspath('hadolint'))
    ],
    'targets': ['hadolint/bin'],
    'clean': [rm_bin]
  }
