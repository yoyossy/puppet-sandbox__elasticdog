import os
import unittest

from ansible.inventory import Inventory

class TestInventory(unittest.TestCase):

    def setUp(self):
        self.cwd = os.getcwd()
        self.test_dir = os.path.join(self.cwd, 'test')

        self.inventory_file             = os.path.join(self.test_dir, 'simple_hosts')
        self.large_range_inventory_file = os.path.join(self.test_dir, 'large_range')
        self.complex_inventory_file     = os.path.join(self.test_dir, 'complex_hosts')
        self.inventory_script           = os.path.join(self.test_dir, 'inventory_api.py')
        self.inventory_dir              = os.path.join(self.test_dir, 'inventory_dir')

        os.chmod(self.inventory_script, 0755)

    def tearDown(self):
        os.chmod(self.inventory_script, 0644)

    def compare(self, left, right, sort=True):
        if sort:
            left = sorted(left)
            right = sorted(right)
        print left
        print right
        assert left == right

    def simple_inventory(self):
        return Inventory(self.inventory_file)

    def large_range_inventory(self):
        return Inventory(self.large_range_inventory_file)

    def script_inventory(self):
        return Inventory(self.inventory_script)

    def complex_inventory(self):
        return Inventory(self.complex_inventory_file)

    def dir_inventory(self):
        return Inventory(self.inventory_dir)

    all_simple_hosts=['jupiter', 'saturn', 'zeus', 'hera',
            'cerberus001','cerberus002','cerberus003',
            'cottus99', 'cottus100',
            'poseidon', 'thor', 'odin', 'loki',
            'thrudgelmir0', 'thrudgelmir1', 'thrudgelmir2',
            'thrudgelmir3', 'thrudgelmir4', 'thrudgelmir5',
            'Hotep-a', 'Hotep-b', 'Hotep-c',
            'BastC', 'BastD', ]

    #####################################
    ### Simple inventory format tests

    def test_simple(self):
        inventory = self.simple_inventory()
        hosts = inventory.list_hosts()
        self.assertEqual(sorted(hosts), sorted(self.all_simple_hosts))

    def test_simple_all(self):
        inventory = self.simple_inventory()
        hosts = inventory.list_hosts('all')
        self.assertEqual(sorted(hosts), sorted(self.all_simple_hosts))

    def test_simple_norse(self):
        inventory = self.simple_inventory()
        hosts = inventory.list_hosts("norse")

        expected_hosts=['thor', 'odin', 'loki']
        assert sorted(hosts) == sorted(expected_hosts)

    def test_simple_ungrouped(self):
        inventory = self.simple_inventory()
        hosts = inventory.list_hosts("ungrouped")

        expected_hosts=['jupiter', 'saturn',
                        'thrudgelmir0', 'thrudgelmir1', 'thrudgelmir2',
                        'thrudgelmir3', 'thrudgelmir4', 'thrudgelmir5']
        assert sorted(hosts) == sorted(expected_hosts)

    def test_simple_combined(self):
        inventory = self.simple_inventory()
        hosts = inventory.list_hosts("norse:greek")

        expected_hosts=['zeus', 'hera', 'poseidon',
                        'cerberus001','cerberus002','cerberus003',
                        'cottus99','cottus100',
                        'thor', 'odin', 'loki']
        assert sorted(hosts) == sorted(expected_hosts)

    def test_simple_restrict(self):
        inventory = self.simple_inventory()

        restricted_hosts = ['hera', 'poseidon', 'thor']
        expected_hosts=['zeus', 'hera', 'poseidon',
                        'cerberus001','cerberus002','cerberus003',
                        'cottus99', 'cottus100',
                        'thor', 'odin', 'loki']

        inventory.restrict_to(restricted_hosts)
        hosts = inventory.list_hosts("norse:greek")

        print "Hosts=%s" % hosts
        print "Restricted=%s" % restricted_hosts
        assert sorted(hosts) == sorted(restricted_hosts)

        inventory.lift_restriction()
        hosts = inventory.list_hosts("norse:greek")

        print hosts
        print expected_hosts
        assert sorted(hosts) == sorted(expected_hosts)

    def test_simple_vars(self):
        inventory = self.simple_inventory()
        vars = inventory.get_variables('thor')

        print vars
        assert vars == {'group_names': ['norse'],
                        'inventory_hostname': 'thor',
                        'inventory_hostname_short': 'thor'}

    def test_simple_port(self):
        inventory = self.simple_inventory()
        vars = inventory.get_variables('hera')

        print vars
        expected = { 'ansible_ssh_port': 3000,
                     'group_names': ['greek'],
                     'inventory_hostname': 'hera',
                     'inventory_hostname_short': 'hera' }
        print expected
        assert vars == expected

    def test_large_range(self):
        inventory = self.large_range_inventory()
        hosts = inventory.list_hosts()
        self.assertEqual(sorted(hosts),  sorted('bob%03i' %i  for i in range(0, 143)))

    ###################################################
    ### INI file advanced tests

    def test_complex_vars(self):
        inventory = self.complex_inventory()

        vars = inventory.get_variables('rtp_a')
        print vars

        expected = dict(
            a='1', b='2', c='3', d='10002', e='10003', f='10004 != 10005',
            g='  g  ', h='  h  ', i="'  i  \"", j='"  j',
            rga='1', rgb='2', rgc='3',
            inventory_hostname='rtp_a', inventory_hostname_short='rtp_a',
            group_names=[ 'eastcoast', 'nc', 'redundantgroup', 'redundantgroup2', 'redundantgroup3', 'rtp', 'us' ]
        )
        print vars
        print expected
        assert vars == expected

    def test_complex_group_names(self):
        inventory = self.complex_inventory()
        tests = {
            'host1': [ 'role1' ],
            'host2': [ 'role1', 'role2' ],
            'host3': [ 'role2' ]
        }
        for host, roles in tests.iteritems():
            group_names = inventory.get_variables(host)['group_names']
            assert sorted(group_names) == sorted(roles)

    def test_complex_exclude(self):
        inventory = self.complex_inventory()
        hosts = inventory.list_hosts("nc:florida:!triangle:!orlando")
        expected_hosts = ['miami', 'rtp_a', 'rtp_b', 'rtp_c']
        print "HOSTS=%s" % sorted(hosts)
        print "EXPECTED=%s" % sorted(expected_hosts)
        assert sorted(hosts) == sorted(expected_hosts)

    def test_regex_exclude(self):
        inventory = self.complex_inventory()
        hosts = inventory.list_hosts("~rtp_[ac]")
        expected_hosts = ['rtp_a', 'rtp_c']
        print "HOSTS=%s" % sorted(hosts)
        print "EXPECTED=%s" % sorted(expected_hosts)
        assert sorted(hosts) == sorted(expected_hosts)

    def test_complex_enumeration(self):


        expected1 = ['rtp_a', 'rtp_b']
        expected2 = ['rtp_c', 'tri_a']
        expected3 = ['rtp_b', 'rtp_c', 'tri_a', 'tri_b', 'tri_c']
        expected4 = ['orlando', 'rtp_c', 'tri_a']

        inventory = self.complex_inventory()
        print "ALL NC=%s" % inventory.list_hosts("nc")
        hosts = inventory.list_hosts("nc[0-1]")
        self.compare(hosts, expected1, sort=False)
        hosts = inventory.list_hosts("nc[2-3]")
        self.compare(hosts, expected2, sort=False)
        hosts = inventory.list_hosts("nc[1-99999]")
        self.compare(hosts, expected3, sort=False)
        hosts = inventory.list_hosts("nc[2-3]:florida[1-2]")
        self.compare(hosts, expected4, sort=False)

    def test_complex_intersect(self):
        inventory = self.complex_inventory()
        hosts = inventory.list_hosts("nc:&redundantgroup:!rtp_c")
        self.compare(hosts, ['rtp_a'])
        hosts = inventory.list_hosts("nc:&triangle:!tri_c")
        self.compare(hosts, ['tri_a', 'tri_b'])


    ###################################################
    ### Inventory API tests

    def test_script(self):
        inventory = self.script_inventory()
        hosts = inventory.list_hosts()

        expected_hosts=['jupiter', 'saturn', 'zeus', 'hera', 'poseidon', 'thor', 'odin', 'loki']

        print "Expected: %s"%(expected_hosts)
        print "Got     : %s"%(hosts)
        assert sorted(hosts) == sorted(expected_hosts)

    def test_script_all(self):
        inventory = self.script_inventory()
        hosts = inventory.list_hosts('all')

        expected_hosts=['jupiter', 'saturn', 'zeus', 'hera', 'poseidon', 'thor', 'odin', 'loki']
        assert sorted(hosts) == sorted(expected_hosts)

    def test_script_norse(self):
        inventory = self.script_inventory()
        hosts = inventory.list_hosts("norse")

        expected_hosts=['thor', 'odin', 'loki']
        assert sorted(hosts) == sorted(expected_hosts)

    def test_script_combined(self):
        inventory = self.script_inventory()
        hosts = inventory.list_hosts("norse:greek")

        expected_hosts=['zeus', 'hera', 'poseidon', 'thor', 'odin', 'loki']
        assert sorted(hosts) == sorted(expected_hosts)

    def test_script_restrict(self):
        inventory = self.script_inventory()

        restricted_hosts = ['hera', 'poseidon', 'thor']
        expected_hosts=['zeus', 'hera', 'poseidon', 'thor', 'odin', 'loki']

        inventory.restrict_to(restricted_hosts)
        hosts = inventory.list_hosts("norse:greek")

        assert sorted(hosts) == sorted(restricted_hosts)

        inventory.lift_restriction()
        hosts = inventory.list_hosts("norse:greek")

        assert sorted(hosts) == sorted(expected_hosts)

    def test_script_vars(self):
        inventory = self.script_inventory()
        vars = inventory.get_variables('thor')

        print "VARS=%s" % vars

        assert vars == {'hammer':True,
                        'group_names': ['norse'],
                        'inventory_hostname': 'thor',
                        'inventory_hostname_short': 'thor'}

    def test_hosts_list(self):
        """Test the case when playbook 'hosts' var is a list."""
        inventory = self.script_inventory()
        host_names = sorted(['thor', 'loki', 'odin'])       # Not sure if sorting is in the contract or not
        actual_hosts = inventory.get_hosts(host_names)
        actual_host_names = [host.name for host in actual_hosts]
        assert host_names == actual_host_names

    def test_script_multiple_groups(self):
        inventory = self.script_inventory()
        vars = inventory.get_variables('zeus')

        print "VARS=%s" % vars

        assert vars == {'inventory_hostname': 'zeus',
                        'inventory_hostname_short': 'zeus',
                        'group_names': ['greek', 'major-god']}

    def test_dir_inventory(self):
        inventory = self.dir_inventory()
        vars = inventory.get_variables('zeus')

        print "VARS=%s" % vars

        assert vars == {'inventory_hostname': 'zeus',
                        'inventory_hostname_short': 'zeus',
                        'group_names': ['greek', 'major-god', 'ungrouped'],
                        'var_a': '1'}
