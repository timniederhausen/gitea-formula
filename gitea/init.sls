{% from 'gitea/map.jinja' import gitea %}

gitea_install:
  pkg.installed:
    - name: {{ gitea.package }}

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
