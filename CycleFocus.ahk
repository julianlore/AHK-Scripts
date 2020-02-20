#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#WinActivateForce ; Prevent task bar buttons from flashing
; Function: CycleFocus
; Function to toggle focus between windows with a common title
; e.g. cycle between all windows with the word "Firefox"
CycleFocus(WinTitle){
    SetTitleMatchMode,2 ; Don't require specifying the exact title, match part of the title
    WinGet, Windows, List, %WinTitle%
    ; Whether we should focus at next iteration, i.e. the current window is focused, so we cycle to the next one
    focusNext := false
    focused := false
    ; Make a comma delimited string to be sorted (can't sort arrays by default using Sort)
    WindowsStr =
    Loop, %Windows%
    {
        this_id := Windows%A_Index%
        If !WindowsStr
            WindowsStr = %this_id%
        Else
            WindowsStr = %WindowsStr%,%this_id%
    }
    Sort,WindowsStr,N D, ; Sort numerically with comma as delimiter
    Loop, parse, WindowsStr,`,
    {
        if focusNext
        {
            WinActivate, ahk_id %A_LoopField%
            focused = true
            break
        }
        if WinActive("ahk_id" A_LoopField)
            focusNext = true ; If current window is focused, focus the next window in our list
    }

    ; If none of the windows are focused, focus the first one (if there is one)
    if !focused
        Loop, parse, WindowsStr,`,
    {
        WinActivate, ahk_id %A_LoopField%
        break
    }
}

; Example usage
#f::CycleFocus("Firefox")
; Windows/File explorer windows
#e::CycleFocus("ahk_class CabinetWClass")
