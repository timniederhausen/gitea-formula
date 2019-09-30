{% from 'gitea/map.jinja' import gitea %}
{% from 'gitea/macros.jinja' import sls_block with context %}

gitea_install:
  pkg.installed:
    {{ sls_block(gitea.package) | indent(4) }}

gitea_app_ini:
  ini.options_present:
    - name: {{ gitea.ini_path }}
    - separator: '='
    - sections: {{ gitea.ini | yaml }}

{% set service_function = 'running' if gitea.service_enabled else 'dead' %}

gitea_service:
  service.{{ service_function }}:
    - name: {{ gitea.service }}
    - enable: {{ gitea.service_enabled }}
    - watch:
      - ini: gitea_app_ini
