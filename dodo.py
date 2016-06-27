
from doit.tools import run_once
import os

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
  yield make_test('self', os.getcwd())
