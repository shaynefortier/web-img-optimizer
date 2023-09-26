@echo off
setlocal

REM Create the optimized directory if it doesn't exist
if not exist "optimized" mkdir "optimized"

REM Loop over all jpg, jpeg, and png files
for %%i in (*.jpg, *.jpeg, *.png) do (
    call :resize_image "%%i"
)

for %%i in (*.jpg, *.jpeg, *.png) do (
    call :convert_image "%%i"
    del "%%i"
)

REM End of main script
goto :eof

REM Function to resize images
:resize_image
    set "image=%~1"
    set "sizes=384 512 768 1024 1920"
    for %%s in (%sizes%) do (
        convert "%image%" -resize %%s -strip "./%~n1-%%sw.%~x1"
    )
goto :eof

REM Function to convert images
:convert_image
    set "image=%~1"
    convert "%image%" -strip "./optimized/%~n1.webp"
    convert "%image%" -strip "./optimized/%~n1.avif"
goto :eof