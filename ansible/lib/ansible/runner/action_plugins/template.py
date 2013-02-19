# (c) 2012, Michael DeHaan <michael.dehaan@gmail.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

import os

from ansible import utils
from ansible import errors
from ansible.runner.return_data import ReturnData
import base64

class ActionModule(object):

    def __init__(self, runner):
        self.runner = runner

    def run(self, conn, tmp, module_name, module_args, inject):
        ''' handler for template operations '''

        # note: since this module just calls the copy module, the --check mode support
        # can be implemented entirely over there

        if not self.runner.is_playbook:
            raise errors.AnsibleError("in current versions of ansible, templates are only usable in playbooks")

        # load up options
        options  = utils.parse_kv(module_args)
        source   = options.get('src', None)
        dest     = options.get('dest', None)

        if (source is None and 'first_available_file' not in inject) or dest is None:
            result = dict(failed=True, msg="src and dest are required")
            return ReturnData(conn=conn, comm_ok=False, result=result)

        # if we have first_available_file in our vars
        # look up the files and use the first one we find as src

        if 'first_available_file' in inject:
            found = False
            for fn in self.runner.module_vars.get('first_available_file'):
                fnt = utils.template(self.runner.basedir, fn, inject)
                fnd = utils.path_dwim(self.runner.basedir, fnt)
                if os.path.exists(fnd):
                    source = fnt
                    found = True
                    break
            if not found:
                result = dict(failed=True, msg="could not find src in first_available_file list")
                return ReturnData(conn=conn, comm_ok=False, result=result)
        else:
            source = utils.template(self.runner.basedir, source, inject)

        if dest.endswith("/"):
            base = os.path.basename(source)
            dest = os.path.join(dest, base)

        # template the source data locally & get ready to transfer
        try:
            resultant = utils.template_from_file(self.runner.basedir, source, inject)
        except Exception, e:
            result = dict(failed=True, msg=str(e))
            return ReturnData(conn=conn, comm_ok=False, result=result)

        local_md5 = utils.md5s(resultant)
        remote_md5 = self.runner._remote_md5(conn, tmp, dest)

        if local_md5 != remote_md5:

             # template is different from the remote value

             # if showing diffs, we need to get the remote value
             dest_contents = None

             if self.runner.diff:
                 # using persist_files to keep the temp directory around to avoid needing to grab another
                 dest_result = self.runner._execute_module(conn, tmp, 'slurp', "path=%s" % dest, inject=inject, persist_files=True)
                 if 'content' in dest_result.result:
                     dest_contents = dest_result.result['content']
                     if dest_result.result['encoding'] == 'base64':
                         dest_contents = base64.b64decode(dest_contents)
                     else:
                         raise Exception("unknown encoding, failed: %s" % dest_result.result)
                 else:
                     dest_result = ''
 
             xfered = self.runner._transfer_str(conn, tmp, 'source', resultant)

             # fix file permissions when the copy is done as a different user
             if self.runner.sudo and self.runner.sudo_user != 'root':
                 self.runner._low_level_exec_command(conn, "chmod a+r %s" % xfered, tmp)

             # run the copy module
             module_args = "%s src=%s dest=%s" % (module_args, xfered, dest)

             if self.runner.check:
                 return ReturnData(conn=conn, comm_ok=True, result=dict(changed=True), before_diff_value=dest_contents, after_diff_value=resultant)
             else:
                 res =  self.runner._execute_module(conn, tmp, 'copy', module_args, inject=inject)
                 res.before_diff_value = dest_contents
                 res.after_diff_value = resultant
                 return res
        else:
             return ReturnData(conn=conn, comm_ok=True, result=dict(changed=False))

