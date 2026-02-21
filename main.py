# This is the hook for defining variables, macros and filters
import os
from pathlib import Path


def define_env(env):
    password_key = 'mot de passe'
    login_key = 'login'
    name_key = 'name'
    url_key = 'url'

    @env.macro
    def url_login_mdp(extra_key):
        name = env.variables[extra_key][name_key]
        url = env.variables[extra_key][url_key]
        login = env.variables[extra_key][login_key]
        password = env.variables[extra_key][password_key]
        HTML = """<a href="%s" target="_blank">%s</a> \
            ( <a data-clipboard-text="%s" href="#">%s</a> : \
                <a data-clipboard-text="%s" href="#">%s</a>)"""
        return HTML % (url, name, login, login, password, password_key)

    @env.macro
    def copy_password_link(label):
        password = env.variables[label]
        HTML = """<a data-clipboard-text="%s" href="#">copy password</a>"""
        return HTML % password

    @env.macro
    def copy_clear_text(key, subkey):
        value = env.variables[key][subkey]
        HTML = """<a data-clipboard-text="%s" href="#">%s</a>"""
        return HTML % (value, value)

    @env.macro
    def local_file(key, subkey):
        value = env.variables[key][subkey]
        HTML = """<a href="%s" target="_blank">%s</a>"""
        return HTML % (value, subkey)

    @env.macro
    def local_folder(page_url, rootdir):
        page_path = os.path.join('docs', page_url)
        rel_parent_path = Path(page_path).parent
        HTML = '<ul>\n'
        target_path = os.path.join(rel_parent_path, rootdir)
        for subdir, dirs, files in os.walk(target_path, topdown=False):
            for file in sorted(files):
                file_path = '../'+ rootdir + '/' + file
                HTML += '\t<li>\n'
                HTML += '\t<a href="{}" target="_blank">{}</a>\n'.format(file_path,file)
                HTML += '\t</li>\n'
        HTML += '</ul>\n'
        return HTML
