@echo off
setlocal enabledelayedexpansion

set "input_file=C:\Users\0813\Desktop\easebuzz\src\main\webapp\merchant-form.jsp"
set "output_file=C:\Users\0813\Desktop\easebuzz\src\main\webapp\temp_form.jsp"

set "skip=false"
for /f "delims=" %%a in ('type "%input_file%"') do (
    set "line=%%a"
    if "!line!"=="                    <div class=""form-group"">" set "skip=true"
    if "!skip!"=="false" echo !line!>>"%output_file%"
    if "!line!"=="                    </div>" if "!skip!"=="true" set "skip=false"
)

move "%output_file%" "%input_file%" >nul
del "%input_file%.bak" 2>nul
