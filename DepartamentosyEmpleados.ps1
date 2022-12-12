$file_groups=Import-Csv -Path Departamentos.csv
foreach ($group in $file_groups) {
  New-LocalGroup -Name $group.Nombre -Description $group.Descripcion
}

$file_users=Import-Csv -Path Empleados.csv
foreach ($user in $file_users) {
  $clave=ConvertTo-secureString $user.Password -AsPlainText -Force
  New-LocalUser $user.Password $clave -AccountNeverExpires -PasswordNeverExpires
  Set-LocalUser $user.Password -PasswordNeverExpires $false
  net user $user.Password /logonpasswordchg:yes
  Add-LocalGroupMember -Group $user.Departamentos -Member $user.Password
}
