; This installs your PyQt5-based desktop application and creates a start menu shortcut, builds an uninstaller,
; and adds uninstall information to the registry for Add/Remove Programs.

; To get started, put this script into a folder with your application executable (e.g., supermarket.exe) and the logo.ico file.

; All the other settings can be tweaked by editing the !defines at the top of this script.

!define APPNAME "Supermarket"
!define COMPANYNAME "web3bridge"
!define DESCRIPTION "Your app's short description"
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0
!define HELPURL "http://example.com/support" ; Support Information link
!define UPDATEURL "http://example.com/update" ; Product Updates link
!define ABOUTURL "http://example.com/publisher" ; Publisher link

RequestExecutionLevel admin ; Require admin rights on NT6+ (When UAC is turned on)

InstallDir "$PROGRAMFILES\${COMPANYNAME}\${APPNAME}"

; This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
OutFile "supermarketInstaller.exe"

!include LogicLib.nsh

; Just two pages - install location and installation
Page directory
Page instfiles

!macro VerifyUserIsAdmin
    UserInfo::GetAccountType
    pop $0
    ${If} $0 != "admin" ; Require admin rights on NT4+
        MessageBox MB_ICONSTOP "Administrator rights required!"
        SetErrorLevel 740 ; ERROR_ELEVATION_REQUIRED
        Quit
    ${EndIf}
!macroend

Function .onInit
    SetShellVarContext all
    !insertmacro VerifyUserIsAdmin
FunctionEnd

Section "install"
    ; Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
    SetOutPath $INSTDIR
    ; Copy your PyQt5-based desktop application executable from the "dist" folder to the installation directory
    File "dist\web3bridge\web3bridge"
    ; Add any other files for the install directory (e.g., license files, app data, etc.) here

    ; Uninstaller - See function un.onInit and section "uninstall" for configuration
    WriteUninstaller "$INSTDIR\uninstall.exe"

    ; Start Menu
    CreateDirectory "$SMPROGRAMS\${COMPANYNAME}"
    CreateShortCut "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk" "$INSTDIR\supermarket.exe"

    ; Registry information for Add/Remove Programs
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${COMPANYNAME} - ${APPNAME} - ${DESCRIPTION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMinor" ${VERSIONMINOR}
    ; There is no option for modifying or repairing the install
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1
    ; Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
SectionEnd

; Uninstaller
Function un.onInit
    SetShellVarContext all

    ; Verify the uninstaller - last chance to back out
    MessageBox MB_OKCANCEL "Permanently remove ${APPNAME}?" IDOK next
    Abort
next:
    !insertmacro VerifyUserIsAdmin
FunctionEnd

Section "uninstall"

    ; Remove Start Menu launcher
    Delete "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk"
    ; Try to remove the Start Menu folder - this will only happen if it is empty
    RmDir "$SMPROGRAMS\${COMPANYNAME}"

    ; Remove files
    Delete $INSTDIR\supermarket.exe

    ; Always delete the uninstaller as the last action
    Delete $INSTDIR\uninstall.exe

    ; Try to remove the install directory - this will only happen if it is empty
    RmDir $INSTDIR

    ; Remove uninstaller information from the registry
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"
SectionEnd
