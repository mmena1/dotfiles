import yaml


def test_apt_packages(host):
    stream = host.file('/tmp/apt.yml').content
    ansible_vars = yaml.safe_load(stream)
    for var in ansible_vars:
        pkg = host.package(var)
        assert pkg.is_installed

def test_pacman_packages(host):
    stream = host.file('/tmp/pacman.yml').content
    ansible_vars = yaml.safe_load(stream)
    for var in ansible_vars:
        pkg = host.package(var)
        assert pkg.is_installed
