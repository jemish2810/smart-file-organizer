@echo off
setlocal EnableDelayedExpansion

:: Define extensions and folder mapping (Common and standard file extensions)
set "image_ext=jpg jpeg png gif bmp svg heic webp tiff tif jfif raw cr2 dng nef arw psd ai eps avif ico"
set "video_ext=mp4 mov mkv avi webm flv wmv 3gp m4v mts m2ts"
set "document_ext=pdf doc docx txt xls xlsx ppt pptx csv rtf odt"
set "audio_ext=mp3 wav flac aac m4a ogg"
set "compressed_ext=zip rar 7z tar gz xz bz2 iso dmg"

:: Loop through all files in the current directory
for %%F in (*) do (
    if not "%%~xF"=="" (
        set "folder_name=Other"
        set "subfolder=."
        set "ext=%%~xF"
        set "ext=!ext:~1!"

        :: Check if extension is image
        for %%E in (%image_ext%) do (
            if /I "!ext!"=="%%E" (
                set "folder_name=Image"
                set "subfolder=Others"
                for %%I in (jpg jpeg png gif bmp tif tiff jfif) do if /I "!ext!"=="%%I" set "subfolder=Raster"
                for %%I in (svg ai eps) do if /I "!ext!"=="%%I" set "subfolder=Vector"
                for %%I in (raw cr2 dng nef arw) do if /I "!ext!"=="%%I" set "subfolder=RAW"
                for %%I in (webp avif) do if /I "!ext!"=="%%I" set "subfolder=Web"
                for %%I in (psd) do if /I "!ext!"=="%%I" set "subfolder=Photoshop"
                for %%I in (ico) do if /I "!ext!"=="%%I" set "subfolder=Icon"
            )
        )

        :: Check for document types with subfolders
        for %%E in (%document_ext%) do (
            if /I "!ext!"=="%%E" (
                set "folder_name=Document"
                set "subfolder=Others"
                for %%D in (doc docx rtf odt) do if /I "!ext!"=="%%D" set "subfolder=Word"
                for %%D in (txt) do if /I "!ext!"=="%%D" set "subfolder=Text"
                for %%D in (xls xlsx csv) do if /I "!ext!"=="%%D" set "subfolder=Spreadsheet"
                for %%D in (ppt pptx) do if /I "!ext!"=="%%D" set "subfolder=Presentation"
                for %%D in (pdf) do if /I "!ext!"=="%%D" set "subfolder=PDF"
            )
        )

        :: Check other types
        for %%E in (%video_ext%) do if /I "!ext!"=="%%E" set "folder_name=Video"
        for %%E in (%audio_ext%) do if /I "!ext!"=="%%E" set "folder_name=Audio"
        for %%E in (%compressed_ext%) do if /I "!ext!"=="%%E" set "folder_name=Compressed"

        :: Define final folder path
        if "!folder_name!"=="Image" (
            set "final_folder=!folder_name!\!subfolder!"
        ) else if "!folder_name!"=="Document" (
            set "final_folder=!folder_name!\!subfolder!"
        ) else (
            set "final_folder=!folder_name!"
        )

        if not exist "!final_folder!" mkdir "!final_folder!"
        move "%%F" "!final_folder!" >nul
    )
)

echo Files have been organized into respective folders.
pause
