{ writeShellScriptBin, ... }:

writeShellScriptBin "lastd" ''
  echo /home/msm/Downloads/$(ls /home/msm/Downloads/ -c | head -n 1)
''
