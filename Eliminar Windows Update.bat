@echo off

echo Estas a punto de eliminar Windows Update. Esta accion no es reversible.
set /p "confirm=Quieres continuar? (SI/NO): "
if /i "%confirm%" neq "SI" goto :fin

echo Eliminando las claves del registro...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\waasmedicsvc" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\usosvc" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /f

echo Cambiando el propietario de la carpeta C:\Windows\WaaS...
takeown /f "C:\Windows\WaaS" /r /a

echo Cambiando los permisos de la carpeta C:\Windows\WaaS...
icacls "C:\Windows\WaaS" /grant Administradores:(OI)(CI)F /t /q

echo Eliminando la carpeta C:\Windows\WaaS...
rmdir /s /q "C:\Windows\WaaS"

echo Proceso completado.
echo Este programa fue desarrollado por https://github.com/pinkystudios

echo Creando tarea programada para ejecutar este programa al inicio del sistema...
schtasks /create /tn "EliminarWindowsUpdate" /tr "%~dpnx0" /sc ONSTART /ru SYSTEM /f

echo Tarea programada creada con exito.
pause
goto :eof

:fin
echo Proceso cancelado.
pause
