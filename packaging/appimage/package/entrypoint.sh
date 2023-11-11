# for reference - https://github.com/niess/python-appimage/blob/818fe273c124223ce651e3ba5d439de9a9550cd7/applications/ssh-mitm/entrypoint.sh
{{ python-executable }} -u "${APPDIR}/opt/python{{ python-version }}/lib/python{{ python-version }}/site-packages/myapp/myapp.py" "$@"
