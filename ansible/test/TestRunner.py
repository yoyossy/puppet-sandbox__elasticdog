
# tests are fairly 'live' (but safe to run)
# setup authorized_keys for logged in user such
# that the user can log in as themselves before running tests

import unittest
import getpass
import ansible.runner
import os
import shutil
import time
import tempfile
import urllib2

from nose.plugins.skip import SkipTest

def get_binary(name):
    for directory in os.environ["PATH"].split(os.pathsep):
        path = os.path.join(directory, name)
        if os.path.isfile(path) and os.access(path, os.X_OK):
            return path
    return None

class TestRunner(unittest.TestCase):

    def setUp(self):
        self.user = getpass.getuser()
        self.runner = ansible.runner.Runner(
            module_name='ping',
            module_path='library/',
            module_args='',
            remote_user=self.user,
            remote_pass=None,
            host_list='test/ansible_hosts',
            timeout=5,
            forks=1,
            background=0,
            pattern='all',
            transport='local',
        )
        self.cwd = os.getcwd()
        self.test_dir = os.path.join(self.cwd, 'test')
        self.stage_dir = self._prepare_stage_dir()

    def _prepare_stage_dir(self):
        stage_path = os.path.join(self.test_dir, 'test_data')
        if os.path.exists(stage_path):
            shutil.rmtree(stage_path, ignore_errors=False)
            assert not os.path.exists(stage_path)
        os.makedirs(stage_path)
        assert os.path.exists(stage_path)
        return stage_path

    def _get_test_file(self, filename):
        # get a file inside the test input directory
        filename = os.path.join(self.test_dir, filename)
        assert os.path.exists(filename)
        return filename

    def _get_stage_file(self, filename):
        # get a file inside the test output directory
        filename = os.path.join(self.stage_dir, filename)
        return filename

    def _run(self, module_name, module_args, background=0):
        ''' run a module and get the localhost results '''
        self.runner.module_name = module_name
        args = ' '.join(module_args)
        print "DEBUG: using args=%s" % args
        self.runner.module_args = args
        self.runner.background = background
        results = self.runner.run()
        # when using nosetests this will only show up on failure
        # which is pretty useful
        print "RESULTS=%s" % results
        assert "localhost" in results['contacted']
        return results['contacted']['localhost']

    def test_ping(self):
        result = self._run('ping', [])
        assert "ping" in result

    def test_facter(self):
        if not get_binary("facter"):
            raise SkipTest
        result = self._run('facter', [])
        assert "hostname" in result

    # temporarily disbabled since it occasionally hangs
    # ohai's fault, setup module doesn't actually run this
    # to get ohai's "facts" anyway
    #
    #def test_ohai(self):
    #    if not get_binary("facter"):
    #            raise SkipTest
    #    result = self._run('ohai',[])
    #    assert "hostname" in result

    def test_copy(self):
        # test copy module, change trigger, etc
        input_ = self._get_test_file('sample.j2')
        output = self._get_stage_file('sample.out')
        assert not os.path.exists(output)
        result = self._run('copy', [
            "src=%s" % input_,
            "dest=%s" % output,
        ])
        assert os.path.exists(output)
        data_in = file(input_).read()
        data_out = file(output).read()
        assert data_in == data_out
        assert 'failed' not in result
        assert result['changed'] == True
        assert 'md5sum' in result
        result = self._run('copy', [
            "src=%s" % input_,
            "dest=%s" % output,
        ])
        assert result['changed'] == False

    def test_command(self):
        # test command module, change trigger, etc
        result = self._run('command', [ "/bin/echo", "hi" ])
        assert "failed" not in result
        assert "msg" not in result
        assert result['rc'] == 0
        assert result['stdout'] == 'hi'
        assert result['stderr'] == ''

        result = self._run('command', [ "false" ])
        assert result['rc'] == 1
        assert 'failed' not in result

        result = self._run('command', [ "/usr/bin/this_does_not_exist", "splat" ])
        assert 'msg' in result
        assert 'failed' in result

        result = self._run('shell', [ "/bin/echo", "$HOME" ])
        assert 'failed' not in result
        assert result['rc'] == 0

        result = self._run('command', [ "creates='/tmp/ansible command test'", "chdir=/tmp", "touch", "'ansible command test'" ])
        assert 'changed' in result
        assert result['rc'] == 0

        result = self._run('command', [ "creates='/tmp/ansible command test'", "false" ])
        assert 'skipped' in result

        result = self._run('shell', [ "removes=/tmp/ansible\\ command\\ test", "chdir=/tmp", "rm -f 'ansible command test'; echo $?" ])
        assert 'changed' in result
        assert result['rc'] == 0
        assert result['stdout'] == '0'

        result = self._run('shell', [ "removes=/tmp/ansible\\ command\\ test", "false" ])
        assert 'skipped' in result

    def test_git(self):
        self._run('file',['path=/tmp/gitdemo','state=absent'])
        self._run('file',['path=/tmp/gd','state=absent'])
        self._run('command',['git init gitdemo', 'chdir=/tmp'])
        self._run('command',['touch a', 'chdir=/tmp/gitdemo'])
        self._run('command',['git add *', 'chdir=/tmp/gitdemo'])
        self._run('command',['git commit -m "test commit 2"', 'chdir=/tmp/gitdemo'])
        self._run('command',['touch b', 'chdir=/tmp/gitdemo'])
        self._run('command',['git add *', 'chdir=/tmp/gitdemo'])
        self._run('command',['git commit -m "test commit 2"', 'chdir=/tmp/gitdemo'])
        result = self._run('git', [ "repo=\"file:///tmp/gitdemo\"", "dest=/tmp/gd" ])
        assert result['changed']
        # test the force option not set
        self._run('file',['path=/tmp/gd/a','state=absent'])
        result = self._run('git', [ "repo=\"file:///tmp/gitdemo\"", "dest=/tmp/gd", "force=no" ])
        assert result['failed']
        # test the force option when set
        result = self._run('git', [ "repo=\"file:///tmp/gitdemo\"", "dest=/tmp/gd", "force=yes" ])
        assert result['changed']
    
    def test_file(self):
        filedemo = tempfile.mkstemp()[1]
        assert self._run('file', ['dest=' + filedemo, 'state=directory'])['failed']
        assert os.path.isfile(filedemo)

        assert self._run('file', ['dest=' + filedemo, 'src=/dev/null', 'state=link'])['failed']
        assert os.path.isfile(filedemo)

        res = self._run('file', ['dest=' + filedemo, 'mode=604', 'state=file'])
        print res
        assert res['changed']
        assert os.path.isfile(filedemo) and os.stat(filedemo).st_mode == 0100604

        assert self._run('file', ['dest=' + filedemo, 'state=absent'])['changed']
        assert not os.path.exists(filedemo)
        assert not self._run('file', ['dest=' + filedemo, 'state=absent'])['changed']


        filedemo = tempfile.mkdtemp()
        assert self._run('file', ['dest=' + filedemo, 'state=file'])['failed']
        assert os.path.isdir(filedemo)

        # this used to fail but will now make a 'null' symlink in the directory pointing to dev/null.
        # I feel this is ok but don't want to enforce it with a test.
        #result = self._run('file', ['dest=' + filedemo, 'src=/dev/null', 'state=link'])
        #assert result['failed']
        #assert os.path.isdir(filedemo)

        assert self._run('file', ['dest=' + filedemo, 'mode=701', 'state=directory'])['changed']
        assert os.path.isdir(filedemo) and os.stat(filedemo).st_mode == 040701

        assert self._run('file', ['dest=' + filedemo, 'state=absent'])['changed']
        assert not os.path.exists(filedemo)
        assert not self._run('file', ['dest=' + filedemo, 'state=absent'])['changed']


        tmp_dir = tempfile.mkdtemp()
        filedemo = os.path.join(tmp_dir, 'link')
        os.symlink('/dev/zero', filedemo)
        assert self._run('file', ['dest=' + filedemo, 'state=file'])['failed']
        assert os.path.islink(filedemo)

        assert self._run('file', ['dest=' + filedemo, 'state=directory'])['failed']
        assert os.path.islink(filedemo)

        assert self._run('file', ['dest=' + filedemo, 'src=/dev/null', 'state=link'])['changed']
        assert os.path.islink(filedemo) and os.path.realpath(filedemo) == '/dev/null'

        assert self._run('file', ['dest=' + filedemo, 'state=absent'])['changed']
        assert not os.path.exists(filedemo)
        assert not self._run('file', ['dest=' + filedemo, 'state=absent'])['changed']
        os.rmdir(tmp_dir)

    def test_large_output(self):
        large_path = "/usr/share/dict/words"
        if not os.path.exists(large_path):
            large_path = "/usr/share/dict/cracklib-small"
            if not os.path.exists(large_path):
                raise SkipTest
        # Ensure reading a large amount of output from a command doesn't hang.
        result = self._run('command', [ "/bin/cat", large_path ])
        assert "failed" not in result
        assert "msg" not in result
        assert result['rc'] == 0
        assert len(result['stdout']) > 100000
        assert result['stderr'] == ''

    def test_async(self):
        # test async launch and job status
        # of any particular module
        result = self._run('command', [ get_binary("sleep"), "3" ], background=20)
        assert 'ansible_job_id' in result
        assert 'started' in result
        jid = result['ansible_job_id']
        # no real chance of this op taking a while, but whatever
        time.sleep(5)
        # CLI will abstract this (when polling), but this is how it works internally
        result = self._run('async_status', [ "jid=%s" % jid ])
        # TODO: would be nice to have tests for supervisory process
        # killing job after X seconds
        assert 'finished' in result
        assert 'failed' not in result
        assert 'rc' in result
        assert 'stdout' in result
        assert result['ansible_job_id'] == jid

    def test_fetch(self):
        input_ = self._get_test_file('sample.j2')
        output = os.path.join(self.stage_dir, 'localhost', input_)
        result = self._run('fetch', [ "src=%s" % input_, "dest=%s" % self.stage_dir ])
        assert os.path.exists(output)
        assert open(input_).read() == open(output).read()

    def test_assemble(self):
        input = self._get_test_file('assemble.d')
        output = self._get_stage_file('sample.out')
        result = self._run('assemble', [
            "src=%s" % input,
            "dest=%s" % output,
        ])
        print result
        assert os.path.exists(output)
        out = file(output).read()
        assert out.find("first") != -1
        assert out.find("second") != -1
        assert out.find("third") != -1
        assert result['changed'] == True
        assert 'md5sum' in result
        assert 'failed' not in result
        result = self._run('assemble', [
            "src=%s" % input,
            "dest=%s" % output,
        ])
        print result
        assert result['changed'] == False

